class SeleniumCodeBuilder.Step.NativeWhileStep extends SeleniumCodeBuilder.Step

  @Name: 'While'
  @Tips:
    Description: '条件ループ'
    Params:
      variable: '比較する変数'
      operator: '比較式'
      value:    '比較する値(null判定の場合無効)'
      string:   '比較する値が文字か(null判定の場合無効)'
  @Correspondence:
    firefox: true
    chrome: true
    android: true
    
  default: ()->
    @params =
      variable: SeleniumCodeBuilder.Input.text(null, isString = false)
      operator: SeleniumCodeBuilder.Input.select('!=', ['==', '!=', '>=', '>', '<=', '<', 'null', '!null'])
      value:    SeleniumCodeBuilder.Input.text()
      string:   SeleniumCodeBuilder.Input.check(true)
    @nodes = []

  to: (lang, innerCode, tab) ->
    # 文字列内変数エスケープ前の値を保持
    oldParams = angular.copy(@params)
    super(lang, innerCode, tab)
    # 文字でなければエスケープ前の値を使用
    @params['value'].value = oldParams['value'].value if not @params['string'].value
    switch lang
      when "ruby"
        check = "#{@params['variable'].value} #{@params['operator'].value} #{@params['value'].value}"
        if @params['operator'].value == 'null'
          check = "#{@params['variable'].value} == nil"
        else if @params['operator'].value == '!null'
          check = "#{@params['variable'].value} != nil"
        return """
#{tab}while #{check} do
#{innerCode}
#{tab}end
"""
      when "python"
        wrap = if @params['string'].value then '"' else ''
        unicode = if @params['string'].value then 'u' else ''
        check = "#{@params['variable'].value} #{@params['operator'].value} #{@params['value'].value}"
        if @params['operator'].value == 'null'
          check = "#{@params['variable'].value} is None"
        else if @params['operator'].value == '!null'
          check = "#{@params['variable'].value} is not None"
        return """
#{tab}while #{check}:
#{innerCode}
"""
