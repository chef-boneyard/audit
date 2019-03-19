# encoding: utf-8
# This module is use to support existing array as well as hash of hashes format
# that are being assigned by end user.
#
# In order to provide backward compatibility this module extended by profiles key object
#
module Deprecations
  module Audit
    # ArrayProfile module extend the hash instance object node['audit']['profiles']
    # to add warning & format the array assignment.
    module ArrayProfile
      EXCLUDE_METHODS = [:[]=]
      MUTATOR_METHODS = Chef::Node::Mixin::ImmutablizeArray::DISALLOWED_MUTATOR_METHODS
      # @overload []=(*args)
      # This method provide the support to assign item as hash(key as String|Symbol)
      #
      # @param [String|Symbol] key assigned add as name.
      # @param [Hash] profile attributes the are being assigned.
      #
      # @example format the profile assignment if it is hash of hashes format.
      #
      #    node.default['audit']['profiles']['linux'] = { 'compalince': 'base/linux' }
      #
      # @example Formatted response return
      #    { name: linux, 'compalince': 'base/linux' }
      #
      # @return [Array<Profiles>]
      def []=(key, value)
        # Assume assignment of profles for array if key is integer
        index = key

        if key.is_a?(Integer)
          Chef::Log.warn "Use of a hash array for the node['audit']['profiles'] is deprecated. Please refer to the README and use a hash of hashes."
        else
          index = self.length
          value = { name: key }.merge(Hash.try_convert(value) || {})
        end
        super(index, value)
      end

      # For all methods that may mutate an Array override them and raise warning
      (MUTATOR_METHODS - EXCLUDE_METHODS).each do |mutator|
        define_method(mutator) do |*args, &block|
          Chef::Log.warn "Use of a hash array for the node['audit']['profiles'] is deprecated. Please refer to the README and use a hash of hashes."
          super(*args, &block)
        end
      end
    end

    # HashProfile module extend the hash instance object node['audit'] to track
    # re-assignment of the profiles.
    module HashProfile
      # @overload []=(key, val)
      # WARN msg for the use of array assigment.
      # @param [String|Symbol] key of audit hash.
      # @param [Array] profiles the are being re-assigned.
      #
      # @return [Hash, #key] return hash for non 'profiles' (key, value) pair assign
      #
      def []=(key, val)
        if key.eql?('profiles')
          Chef::Log.warn "Use of a hash array for the node['audit']['profiles'] is deprecated. Please refer to the README and use a hash of hashes." unless val.is_a?(Hash)
          store(key, val)
          self[key].extend(ArrayProfile)
        else
          super(key, val)
        end
      end
    end
  end
end
