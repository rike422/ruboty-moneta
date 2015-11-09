require "moneta"

module Ruboty
  module Brains
    class Moneta < Base
      KEY = "brain"

      attr_reader :thread
      env :MONETA_BACKEND, "use moneta db backend"
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
        Ruboty.die("#{self.class.usage}") unless backend
      end

      private

      def push
        store[KEY] = Marshal.dump(data)
      end

      def pull
        if str = store[KEY]
          Marshal.load(str)
        end
      rescue TypeError
      end

      def sync
        loop do
          wait
          push
        end
      end

      def backend
        @backend ||= (ENV["MONETA_BACKEND"] || "Memory").to_sym
      end

      def wait
        sleep(interval)
      end

      def store
        @store||= ::Moneta.new(backend, moneta_option)
      end

      def moneta_option
        prefix = backend.to_s.underscore.upcase
        ENV.reduce({}) do |option, env|
          match = env[0].to_s.match(/MONETA_#{prefix}_([A-Z_]+)$/)
          next option if match.nil?
          option[match[1].downcase.to_sym] = env[1]
          option
        end
      end

      def namespace
        ENV["MONETA_NAMESPACE"] || "ruboty"
      end

      def interval
        (ENV["MONETA_SAVE_INTERVAL"] || 5).to_i
      end
    end
  end
end
