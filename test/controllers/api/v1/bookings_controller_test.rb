require 'test_helper'

class Api::V1::BookingsControllerTest < ActionDispatch::IntegrationTest

  before do
    Timecop.freeze(Time.current)
  end

  after do
    Timecop.return
  end

  describe "index" do

    before do
      @uri = "/api/v1/bookings"

      3.times { Fabricate.create(:booking) }
    end

    describe "when authenticated" do

      before { @headers = authenticate! }

      it "returns 200 | ok" do
        get @uri, headers: @headers
        assert_response 200
      end

      it "returns collection of bookings" do
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

    describe "when including rentals in response" do

      before do
        @headers = authenticate!
        @uri << "?include=rentals"
      end

      it "works" do
        get @uri, headers: @headers

        assert_response 200

        content = json(@response.body)

        assert_not_nil content[:included]
      end
    end

  end

  describe "show" do

    before do
      Timecop.freeze(Time.current) do
        @booking = Fabricate.create(:booking,
          start_at: Time.current,
          end_at: Time.current + 5.days)
      end

      @uri = "/api/v1/bookings/#{@booking.id}"
    end

    describe "when authenticated" do

      before { @headers = authenticate! }

      describe "and resource exists" do

        it "returns 200 | ok" do
          get @uri, headers: @headers
          assert_response 200
        end

        it "returns json representation for booking" do
          get @uri, headers: @headers

          content = json(@response.body)

          assert_equal @booking.id, content[:data][:id].to_i
        end
      end

      describe "and resource does not exist" do

        before { @uri = "/api/v1/bookings/-100" }

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
      Timecop.freeze(Time.current) do
        @new_time = Time.current + 21.days
        @booking = Fabricate.create(:booking)
        @booking.end_at = @new_time
      end

      @resource = json_document_for(@booking, Api::V1::BookingSerializer)
      @uri      = "/api/v1/bookings/#{@booking.id}"
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

        assert_equal @booking.id, content[:data][:id].to_i
        assert_equal Time.parse(@new_time.to_s), Time.parse(content[:data][:attributes][:end_at])
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
      @uri = "/api/v1/bookings"
      @rental = Fabricate.create(:rental, daily_rate: 150)
      @params = {
        data: {
          type: "Booking",
          attributes: {
            start_at: Time.current + 1.hour,
            end_at: Time.current + 2.days,
            client_email: "charles@gmail.com",
          },
          relationships: {
            rental: {
              data: { id: @rental.id, type: "rental" }
            }
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

        assert_equal "bookings", content[:data][:type]
      end

      it "increases number of bookings by 1" do
        assert_difference "Booking.count" do
          post @uri, params: @params, headers: @headers
        end
      end

      describe "with invalid params" do

        before { @params[:data][:attributes][:end_at] = 1.day.ago }

        it "returns 422 | unprocessible entity" do
          post @uri, params: @params, headers: @headers
          assert_response 422
        end

        it "returns error" do
          post @uri, params: @params, headers: @headers

          content = json @response.body

          assert_equal "/data/attributes/end_at", content[:errors].first[:source][:pointer]
        end

      end

      describe "price" do

        before { @params[:data][:attributes][:price] = 1000 }

        it "cannot be assigned" do
          post @uri, params: @params, headers: @headers

          content = json @response.body

          assert_equal "150.0", content[:data][:attributes][:price]
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

  describe "destroy" do

    before do
      @booking = Fabricate.create(:booking)
      @uri = "/api/v1/bookings/#{@booking.id}"
    end

    describe "when authenticated" do

      before { @headers = authenticate! }

      describe "and resource exists" do

        it "returns 204 | no content" do
          delete @uri, headers: @headers
          assert_response 204
        end

      end

      describe "and resource does not exist" do

        before { @uri = "/api/v1/bookings/-100" }

        it "returns 404 | not found" do
          delete @uri, headers: @headers
          assert_response 404
        end

      end

    end

    describe "when not authenticated" do

      it "returns 401 | unauthorized" do
        delete @uri, headers: {}
        assert_response 401
      end

    end

  end

end
