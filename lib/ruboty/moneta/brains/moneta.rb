require "moneta"

module Ruboty
  module Brains
    class Moneta < Base
      KEY = "brain"

      attr_reader :thread
      env :MONETA_BACKEND, "use moneta backend (default: memory)"
      env :MONETA_BACKEND_SLAVE, "use cloning data to slaves (defalut: nil)", optional: true
      env :MONETA_SAVE_INTERVAL, "Interval sec to push data to moneta (default: 5)", optional: true
      env :MONETA_NAMESPACE, "Moneta name space (default: ruboty)", optional: true

      def initialize
        super
        @thread = Thread.new { sync }
        @thread.abort_on_exception = true
      end

      def data
        @data ||= pull || {}
      end

      # Override.
      def validate!
        super
        Ruboty.die("#{self.class.usage}") unless master_backend
      end

      private

      def push
        master[KEY] = Marshal.dump(data)
      end

      def pull
        if str = master[KEY]
          Marshal.load(str)
        end
      rescue TypeError
      end

      def replicate
        slaves.each do |slave|
          slave[KEY] = Marshal.dump(data)
        end
      end

      def wait
        sleep(interval)
      end

      def sync
        loop do
          wait
          push
          replicate
        end
      end

      def interval
        (ENV["MONETA_SAVE_INTERVAL"] || 5).to_i
      end

      def master_backend
        (ENV["MONETA_BACKEND"] || "Memory").to_sym
      end

      def slave_backend
        eval(ENV["MONETA_BACKEND_SLAVE"])
      rescue NameError
        ENV["MONETA_BACKEND_SLAVE"]
      end

      def fetch_option(backend)
        prefix = backend.to_s.underscore.upcase
        ENV.reduce({}) do |option, env|
          match = env[0].to_s.match(/MONETA_#{prefix}_([A-Z_]+)$/)
          next option if match.nil?
          option[match[1].downcase.to_sym] = env[1]
          option
        end
      end

      def master
        @master ||= ::Moneta.new(master_backend, fetch_option(master_backend))
      end

      def slaves
        @slaves ||=
        if slave_backend.is_a?(String)
          [::Moneta.new(slave_backend.to_sym, fetch_option(slave_backend))]
        elsif slave_backend.is_a?(Array)
          slave_backend.map do |slave_name|
            ::Moneta.new(slave_name.to_sym, fetch_option(slave_name))
          end
        else
          []
        end
      end
    end
  end
end
