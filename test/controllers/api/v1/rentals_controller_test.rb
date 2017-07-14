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

  describe "update" do

    before do
      @rental = Fabricate.create(:rental, name: "Car", daily_rate: 250.00)

      @rental.name = "Boat"

      @resource = json_document_for(@rental, Api::V1::RentalSerializer)
      @uri      = "/api/v1/rentals/#{@rental.id}"
    end

    describe "when authenticated" do

      before { @headers = authenticate! }

      it "returns 200 | ok" do
        put @uri, params: @resource.as_json, headers: @headers
        assert_response 200
      end

      it "returns updated resource" do
        put @uri, params: @resource.as_json, headers: @headers

        content = json(@response.body)

        assert_equal @rental.id, content[:data][:id].to_i
        assert_equal "Boat", content[:data][:attributes][:name]
      end
    end

    describe "when not authenticated" do

      it "returns 401 | unauthorized" do
        put @uri, params: @resource.as_json, headers: {}
        assert_response 401
      end

    end

  end

  describe "create" do

    before do
      @uri = "/api/v1/rentals"
      @params = {
        data: {
          type: "Rental",
          attributes: {
            name: "Car",
            daily_rate: 250.00
          }
        }
      }
    end

    describe "when authenticated" do

      before { @headers = authenticate! }

      it "returns 201 | created" do
        post @uri, params: @params, headers: @headers
        assert_response 201
      end

      it "returns new resource" do
        post @uri, params: @params, headers: @headers

        content = json(@response.body)

        assert_equal "Car", content[:data][:attributes][:name]
      end

      it "increases number of rentals by 1" do
        assert_difference "Rental.count" do
          post @uri, params: @params, headers: @headers
        end
      end

      describe "with invalid params" do

        before { @params[:data][:attributes][:daily_rate] = -100.00 }

        it "returns 422 | unprocessible entity" do
          post @uri, params: @params, headers: @headers
          assert_response 422
        end

        it "returns error" do
          post @uri, params: @params, headers: @headers

          content = json @response.body

          assert_equal "/data/attributes/daily_rate", content[:errors].first[:source][:pointer]
        end

      end

    end

    describe "when not authenticated" do

      it "returns 401 | unauthorized" do
        post @uri, params: @params, headers: @headers
        assert_response 401
      end

    end

  end

end
