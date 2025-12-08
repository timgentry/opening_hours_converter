require 'opening_hours_converter'

describe OpeningHoursConverter::Tokenizer do
  describe '#tokenize' do
    context 'verifying mutable string creation' do
      it 'creates mutable strings when tokenizing days' do
        tokenizer = OpeningHoursConverter::Tokenizer.new('Mo-Fr 08:00-18:00')
        expect(tokenizer.tokens).to be_an(Array)
        # Verify all token values are mutable (not frozen)
        tokenizer.tokens.each do |token|
          expect(token).not_to be_frozen
        end
      end

      it 'creates mutable strings when tokenizing times' do
        tokenizer = OpeningHoursConverter::Tokenizer.new('08:00-18:00')
        expect(tokenizer.tokens).to include('08:00-18:00')
        tokenizer.tokens.each do |token|
          expect(token).not_to be_frozen
        end
      end

      it 'creates mutable strings when tokenizing years' do
        tokenizer = OpeningHoursConverter::Tokenizer.new('2017-2018 Mo 08:00-10:00')
        expect(tokenizer.tokens).to be_an(Array)
        tokenizer.tokens.each do |token|
          expect(token).not_to be_frozen
        end
      end

      it 'creates mutable strings when tokenizing 24/7' do
        tokenizer = OpeningHoursConverter::Tokenizer.new('24/7')
        expect(tokenizer.tokens).to eq(['24/7'])
        expect(tokenizer.tokens.first).not_to be_frozen
      end

      it 'creates mutable strings when tokenizing day ranges' do
        tokenizer = OpeningHoursConverter::Tokenizer.new('Mo-We 08:00-10:00')
        expect(tokenizer.tokens).to be_an(Array)
        expect(tokenizer.tokens.length).to be > 0
        tokenizer.tokens.each do |token|
          expect(token).not_to be_frozen
        end
      end

      it 'creates mutable strings when tokenizing with quotes' do
        tokenizer = OpeningHoursConverter::Tokenizer.new('Mo-We 08:00-10:00 "salut"')
        expect(tokenizer.tokens).to be_an(Array)
        tokenizer.tokens.each do |token|
          expect(token).not_to be_frozen
        end
      end

      it 'creates mutable strings when tokenizing PH (public holidays)' do
        tokenizer = OpeningHoursConverter::Tokenizer.new('PH off')
        expect(tokenizer.tokens).to eq(['PH', 'off'])
        tokenizer.tokens.each do |token|
          expect(token).not_to be_frozen
        end
      end

      it 'creates mutable strings when tokenizing month ranges' do
        tokenizer = OpeningHoursConverter::Tokenizer.new('2017 Jun-Jul Sa 10:00-12:00')
        expect(tokenizer.tokens).to be_an(Array)
        tokenizer.tokens.each do |token|
          expect(token).not_to be_frozen
        end
      end

      it 'creates mutable strings when tokenizing date ranges' do
        tokenizer = OpeningHoursConverter::Tokenizer.new('Nov 11-12 10:00-23:00')
        expect(tokenizer.tokens).to be_an(Array)
        tokenizer.tokens.each do |token|
          expect(token).not_to be_frozen
        end
      end

      it 'creates mutable strings for empty input' do
        tokenizer = OpeningHoursConverter::Tokenizer.new('')
        expect(tokenizer.tokens).to eq([])
      end

      it 'creates mutable strings when tokenizing week ranges' do
        tokenizer = OpeningHoursConverter::Tokenizer.new('week 1 off')
        expect(tokenizer.tokens).to be_an(Array)
        tokenizer.tokens.each do |token|
          expect(token).not_to be_frozen
        end
      end
    end

    context 'integration with existing parser tests' do
      it 'works correctly with the full parser' do
        # This test verifies the tokenizer works end-to-end with the parser
        input = 'Mo 08:00-10:00'
        parsed = OpeningHoursConverter::OpeningHoursParser.new.parse(input)
        rebuilt = OpeningHoursConverter::OpeningHoursBuilder.new.build(parsed)
        expect(rebuilt).to eq(input)
      end
    end
  end
end