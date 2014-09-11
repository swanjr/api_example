require 'spec_helper'

require 'security/errors'
require 'security/getty_token_analyzer'

describe Security::GettyTokenAnalyzer do
  before(:context) do
    described_class.configure do |config|
      config.sts_public_key = 'rmxWUDxTISNTbVte2csm5alfXNEoFQo9NcdKriIVmk11QhPbNgIvTuQg2o+7MleCLcydC7PMpxIwTd7ZNiQtbivd2N\/pAsLjjhKNDNo9GFd4EhWK6T1Lq3Fm+mWYY2sbtNc4bPm158U9vVDKEeHLY4y01KoHZ7YTzH2tzA4XwEU='
    end
  end

  let(:valid_token) { 'YlGeha7EwdDiNmqnK6tIC78bl82YU80NX1RUzq0BRTxMIT6K77jJTdi4JUnw8vUE5dNgzrT68pP6rxLLOHxoJvqmf+Cq/s8WQ4FBLnDk7AP9XDRH8PhvUuSUMXMTLeCimz1cvCNa8J67JL1KPYf+e+Cy8uq3D8YdsfmExO709BA=|77u/SlZ2R2JQMEJTZHVQeDdlZ1h3TUYKMTAwCjMxNAo0ME1KQkE9PQpBR3E5SXc9PQowCgoxMS4yMi4zMy40NAowCgpBQkNNTmc9PQo=|3' }

  describe "#initialize" do

    context 'with a valid token' do
      let!(:analyzer) { described_class.new(valid_token) }

      it "sets token" do
        expect(analyzer.token).to eq(valid_token)
      end

      it "parses signature from token" do
        expect(analyzer.signature).to eq("YlGeha7EwdDiNmqnK6tIC78bl82YU80NX1RUzq0BRTxMIT6K77jJTdi4JUnw8vUE5dNgzrT68pP6rxLLOHxoJvqmf+Cq/s8WQ4FBLnDk7AP9XDRH8PhvUuSUMXMTLeCimz1cvCNa8J67JL1KPYf+e+Cy8uq3D8YdsfmExO709BA=")
      end

      it "parses version from token if available" do
        expect(analyzer.version).to eq('3')
      end

      it "parses system_id from token" do
        expect(analyzer.system_id).to eq('100')
      end

      it "parses account_id from token" do
        expect(analyzer.account_id).to eq('314')
      end

      it "parses expired_at from token" do
        expect(analyzer.expires_at).to eq(DateTime.new(2030, 1, 1))
      end

      describe '#authentic?' do
        it 'returns true' do
          expect(analyzer.authentic?).to be(true)
        end
      end

    end
  end

  context 'with a malformed token' do
    let(:malformed_token) { 'YlGeha7EwdDiNmqnK6tIC78bl82YU80NX1RUzq0BRTxMIT6K77jJTdi4JUnw8vUE5dNgzrT68pP6rxLLOHxoJvqmf+Cq/s8WQ4FBLnDk7AP9XDRH8PhvUuSUMXMTLeCimz1cvCNa8J67JL1KPYf+e+Cy8uq3D8YdsfmExO709BA=' }
    let!(:analyzer) {  }

    it 'throws a MalformedTokenError if token is incorrectly formatted' do
      expect { described_class.new(malformed_token) }.to raise_error(Security::MalformedTokenError)
    end

    it 'throws a MalformedTokenError if token is blank' do
      expect { described_class.new(malformed_token) }.to raise_error(Security::MalformedTokenError)
    end
  end

  context 'with an invalid token' do
    let(:invalid_token) { 'YlGeha7EwdDiNmqnK6tIC78bl82YU80NX1RUzq0BRTxMIT6K77jJTdi4JUnw8vUE5dNgzrT68pP6rxLLOHxoJvqmf+Cq/s8WQ4FBLnDk7AP9XDRH8PhvUuSUMXMTLeCimz1cvCNa8J67JL1KPYf+e+Cy8uq3D8YdsfmExO709BA=|77u/SlZ2R2JQMEJTZHVQeDdlZ1h3TUYKMTAwCjMxNAo0ME1KQkE9PQpBR3E5SXc9PQowCgoxMS4yMi4zMy40NAowCgpBQkNNTmc9Pqo=|3' }
    let!(:analyzer) { described_class.new(invalid_token) }

    describe '#authentic?' do
      it 'returns false' do
        expect(analyzer.authentic?).to be(false)
      end
    end
  end

  context 'with an expired token' do
    let(:expired_token) { 'fsc8XeAFaufBr8HIFNiXSQHpgzGd3LdbeSR2H/CK9rg4dQqs3hta/Uje2w8WNOss9ChwSL8x5RgaORgIy9JZYVYR1Cym2uOHDywQ/qsU1ivba6TntcGXGGZYkh5qvwfO16GjqSeMryYZb5e1Q1JxEnj47jWSKhjUmCf91+EzaDM=|77u/dzYyb0Rjb2tEeFpjZW9teGhOdzQKMTAwCjMxNAo0ME1KQkE9PQpBQUFBQUE9PQowCgoxMS4yMi4zMy40NAowCgpBQkNNTmc9PQo=|3' }
    let!(:analyzer) { described_class.new(expired_token) }

    describe '#authentic?' do
      it 'returns true' do
        expect(analyzer.authentic?).to be(true)
      end
    end
  end
end
