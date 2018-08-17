# frozen_string_literal: true

module RuboCop
  module Cop
    module RSpec
      # Checks for usage of implicit subject (`is_expected`).
      #
      # This cop can be configured using the `EnforcedStyle` option
      #
      # @example `EnforcedStyle: single_line_only`
      #   # bad
      #   it do
      #     is_expected.to be_truthy
      #   end
      #
      #   # good
      #   it { is_expected.to be_truthy }
      #   it do
      #     expect(subject).to be_truthy
      #   end
      #
      # @example `EnforcedStyle: disallow`
      #   # bad
      #   it { is_expected.to be_truthy }
      #
      #   # good
      #   it { expect(subject).to be_truthy }
      #
      class ImplicitSubject < Cop
        include ConfigurableEnforcedStyle

        MSG = "Don't use implicit subject.".freeze

        def_node_matcher :implicit_subject?, '(send nil? :is_expected)'

        def on_send(node)
          return unless implicit_subject?(node)
          return if valid_usage?(node)

          add_offense(node)
        end

        def autocorrect(node)
          replacement = 'expect(subject)'
          ->(corrector) { corrector.replace(node.loc.selector, replacement) }
        end

        private

        def valid_usage?(node)
          style == :single_line_only &&
            node.ancestors.find { |parent| example?(parent) }.single_line?
        end
      end
    end
  end
end
