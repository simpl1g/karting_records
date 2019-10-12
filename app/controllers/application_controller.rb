# frozen_string_literal: true

require 'net/http'

class ApplicationController < ActionController::Base
  def root
    @europe_top = europe_top
    @korona_top = korona_top
    @procup_top = procup_top
  end

  private

  def europe_top
    Rails.cache.fetch('europe', expires_in: 5.minutes) do
      response = Net::HTTP.get(URI('http://178.124.223.165:1988/tv/raceStatus.php'))
      tops = JSON.parse(response)['records'].find { |r| r['type'].start_with?('TOP Трассы') }['tops']

      tops.map { |row| row.slice('name', 'time') }
    end
  end

  def korona_top
    Rails.cache.fetch('korona', expires_in: 5.minutes) do
      response = Net::HTTP.get(URI('http://178.124.156.40:1988/tv/raceStatus.php'))
      tops = JSON.parse(response)['records'].find { |r| r['type'].start_with?('TOP ТРАССЫ') }['tops']

      tops.map { |row| row.slice('name', 'time') }
    end
  end

  def procup_top
    Rails.cache.fetch('procup', expires_in: 5.minutes) do
      response = Net::HTTP.get(URI('http://178.124.156.40:1988/tv/raceStatus.php'))
      tops = JSON.parse(response)['records'].find { |r| r['type'].start_with?('PRO Cup (Mojo)') }['tops']

      tops.map { |row| row.slice('name', 'time') }
    end
  end
end
