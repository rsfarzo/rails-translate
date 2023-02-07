class TranslateController < ApplicationController
  before_action :set_defaults
  def index
  end

  def translate_params
    params.permit(:source, :source_language, :destination_language)
  end

  def translate
    @source = translate_params[:source]
    @source_language = translate_params[:source_language]
    @destination_language = translate_params[:destination_language]
    body = {
      q: @source,
      target: @destination_language.upcase
    }
    body[:source] = @source_language.downcase unless @source_language.empty?
    translate = api_request(
      'language/translate/v2', 
      method: :post,
      body: URI.encode_www_form(body)
    )
    @translate = translate['data']['translate'].first['translatedText']
    render action: :index
  end


  #private
  def set_defaults
    @languages = fetch_languages
  end

  def api_request(path, method: :get, body: nil)
    params = {
      headers: {
        'Accept-Encoding' = 'application/gzip'
        'x-rapidapi-key': '102af2a43cmshb712411545b21b3p121e3cjsn0cc724e8fb83',
        'content-type': 'application/x-www-form-urlencoded'
      }
    }
    params[:body] = body if body
    response = Excon.send(method,
      "https://google-translate1.p.rapidapi.com/#{path}",
      params
    )
    JSON.parse(response.body)
  end

  def fetch_languages
    url = URI("https://google-translate1.p.rapidapi.com/language/translate/v2/languages")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["Accept-Encoding"] = 'application/gzip'
    request["X-RapidAPI-Key"] = 'ceec4bda6emsh567ef488afa9e53p13853djsn7ea67897cb8f'
    request["X-RapidAPI-Host"] = 'google-translate1.p.rapidapi.com'

    response = http.request(request)
    puts response.read_body

    languages = api_request('language/translate/v2/languages')
    keys = languages['data']['languages'].map { |l| l['language'].upcase }
    I18nData
      .languages
      .slice(*keys)
      .each_with_object([]) do |(iso, name), memo|
        memo << [name, iso]
      end
  end

end
