RSpec.describe RuboCop::Cop::RSpec::ImplicitSubject, :config do
  subject(:cop) { described_class.new(config) }

  let(:cop_config) do
    { 'EnforcedStyle' => enforced_style }
  end

  context 'with EnforcedStyle `single_line_only`' do
    let(:enforced_style) { 'single_line_only' }

    it 'flags `is_expected` in multi-line examples' do
      expect_offense(<<-RUBY)
        it 'expect subject to be used' do
          is_expected.to be_good
          ^^^^^^^^^^^ Don't use implicit subject.
        end
      RUBY
    end

    it 'allows `is_expected` in single-line examples' do
      expect_no_offenses(<<-RUBY)
        it { is_expected.to be_good }
      RUBY
    end

    bad_code = <<-RUBY
      it 'works' do
        is_expected.to be_truthy
      end
    RUBY

    good_code = <<-RUBY
      it 'works' do
        expect(subject).to be_truthy
      end
    RUBY

    include_examples 'autocorrect',
                     bad_code,
                     good_code
  end

  context 'with EnforcedStyle `disallow`' do
    let(:enforced_style) { 'disallow' }

    it 'flags `is_expected` in multi-line examples' do
      expect_offense(<<-RUBY)
        it 'expect subject to be used' do
          is_expected.to be_good
          ^^^^^^^^^^^ Don't use implicit subject.
        end
      RUBY
    end

    it 'flags `is_expected` in single-line examples' do
      expect_offense(<<-RUBY)
        it { is_expected.to be_good }
             ^^^^^^^^^^^ Don't use implicit subject.
      RUBY
    end

    include_examples 'autocorrect',
                     'it { is_expected.to be_truthy }',
                     'it { expect(subject).to be_truthy }'
  end
end
