class HealthController < ApplicationController
  def index
    health_status = {
      status: "ok",
      timestamp: Time.current.iso8601,
      service: "b2b-monorepo-backend",
      version: "1.0.0",
      checks: {
        database: check_database,
        rails: check_rails
      }
    }

    if all_checks_healthy?(health_status[:checks])
      render json: health_status, status: :ok
    else
      health_status[:status] = "error"
      render json: health_status, status: :service_unavailable
    end
  end

  private

  def check_database
    ActiveRecord::Base.connection.execute("SELECT 1")
    {
      status: "healthy",
      message: "Database connection successful"
    }
  rescue StandardError => e
    {
      status: "unhealthy",
      message: "Database connection failed",
      error: e.message
    }
  end

  def check_rails
    {
      status: "healthy",
      message: "Rails application is running",
      environment: Rails.env
    }
  end

  def all_checks_healthy?(checks)
    checks.values.all? { |check| check[:status] == "healthy" }
  end
end
