class SeleniumCodeBuilder.Step.ElementGetElementsStep extends SeleniumCodeBuilder.Step

  @Name: 'Get Elements'
  @Tips:
    Description: '複数の要素を取得する(取れない場合NULL)'
    Params:
      location:   'CSSセレクタ'
      variable:   '変数名'
  @Correspondence:
    firefox: true
    chrome: true
    android: true

  default: ()->
    @params =
      location:   SeleniumCodeBuilder.Input.text()
      variable:   SeleniumCodeBuilder.Input.text(null, isString = false)
    @nodes = null

  to: (lang, innerCode, tab) ->
    super(lang, innerCode, tab)
    switch lang
      when "ruby"
        return """
#{tab}begin
#{tab}  #{@params['variable'].value} = _wait.until { _driver.find_elements(css: #{@params['location'].value}) }
#{tab}rescue => e
#{tab}end
"""
      when "python"
        return """
#{tab}try:
#{tab}  #{@params['variable'].value} = _wait.until(lambda _driver: _driver.find_elements(By.CSS_SELECTOR, #{@params['location'].value}))
#{tab}except:
#{tab}  #{@params['variable'].value} =  None
"""
