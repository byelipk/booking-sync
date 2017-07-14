require 'test_helper'

class Api::V1::RentalsControllerTest < ActionDispatch::IntegrationTest

  describe "index" do

    before do
      @uri = "/api/v1/rentals"

      3.times { Fabricate.create(:rental) }
    end

    describe "when authenticated" do

      before { @headers = authenticate! }

      it "returns 200 | ok" do
        get @uri, headers: @headers
        assert_response 200
      end

      it "returns collection of rentals" do
        get @uri, headers: @headers

        content = json(@response.body)

        assert_equal 3, content[:data].length
      end

    end

    describe "when not authenticated" do

      it "returns 401 | unauthorized" do
        get @uri, headers: {}
        assert_response 401
      end

    end

  end

  describe "show" do

    before do
      @rental = Fabricate.create(:rental,
        name: "Car",
        daily_rate: 250.00)

      Timecop.freeze(DateTime.now) do
        @booking = Fabricate.create(:booking,
          rental: @rental,
          start_at: DateTime.now,
          end_at: DateTime.now + 5.days)
      end

      @uri = "/api/v1/rentals/#{@rental.id}"
    end

    describe "when authenticated" do

      before { @headers = authenticate! }

      describe "and resource exists" do

        it "returns 200 | ok" do
          get @uri, headers: @headers
          assert_response 200
        end

        it "returns json representation for rental" do
          get @uri, headers: @headers

          content = json(@response.body)

          assert_equal @rental.id, content[:data][:id].to_i
        end
      end

      describe "and resource does not exist" do

        before { @uri = "/api/v1/rentals/-100" }

        it "returns 404 | not found" do
          get @uri, headers: @headers
          assert_response 404
        end

      end

    end

    describe "when not authenticated" do

      it "returns 401 | unauthorized" do
        get @uri, headers: {}
        assert_response 401
      end

    end

  end

end
