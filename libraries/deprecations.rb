# encoding: utf-8
# This module is use to support existing array as well as hash of hashes format
# that are being assigned by end user.
#
# In order to provide backword compativility this module extended by profiles key object
#
module Deprecations
  module Audit
    # ArrayProfile module extend the hash instance object node['audit']['profiles']
    # to add warning & format the array assignment.
    module ArrayProfile
      # @overload []=(*args)
      # This method provide the support to assign item as hash(key as String|Symbole)
      #
      # @param [String|Symbole] key assigned add as name.
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
      def []=(*args)
        self << { name: args.first }.merge(Hash.try_convert(args.last) || {})
      end

      # @overload push(*args)
      # WARN msg for the deprication use of array assigment.
      # @param [Array] Profiles the are being assigned.
      #
      # @return [Array<Profiles>]
      def push(*args)
        Chef::Log.warn "Use of a hash array for the node['audit']['profiles'] is deprecated. Please refer to the README and use a hash of hashes."
        super(*args)
      end
    end

    # HashProfile module extend the hash instance object node['audit'] to track
    # re-assignment of the profiles.
    module HashProfile
      # @overload []=(key, val)
      # WARN msg for the deprication use of array assigment.
      # @param [String|Symbole] key of audit hash.
      # @param [Array] profiles the are being re-assigned.
      #
      # @return [Hash, #key] return hash for non 'profiles' (key, value) pair assign
      #
      def []=(key, val)
        if key.eql?('profiles')
          Chef::Log.warn "Use of a hash array for the node['audit']['profiles'] is deprecated. Please refer to the README and use a hash of hashes."
          store(key, val)
          self[key].extend(ArrayProfile)
        else
          super(key, val)
        end
      end
    end
  end
end
