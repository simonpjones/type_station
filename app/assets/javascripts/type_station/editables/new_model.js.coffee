buildFields = (element) ->
  $element = $(element)
  $ul = $('<ul/>').addClass("ts-model-fields")
  tsFields = $element.data('tsFields')
  tsNewUrl = $element.data('tsNewUrl')
  tsParentId = $element.data('tsParentId')

  liClass = if tsFields.length == 1 then 'ts-inline-field' else ''

  for field in tsFields
    $li = $('<li/>')
    $input = $('<input/>')

    $input
      .attr({type: "text", name: "text", placeholder: window.titleize field})
      .data({'ts-field': field, 'ts-new-url': tsNewUrl})
      .on 'change', (e) ->
        $(@).parent().parent().data($(@).data('ts-field'), $(@).val())
      .appendTo($li)

    $li.addClass(liClass).appendTo($ul)

  $li = $('<li/>').addClass(liClass)
  $button = $('<button/>')
  $button
    .html('<i class="ion-android-add"></i>')
    .addClass('ts-button')
    .addClass('ts-button-primary')
    .data({'ts-field': field, 'ts-new-url': tsNewUrl, 'ts-parent-id': tsParentId})
    .on 'click', ->
      data = {}
      data[$(@).data('ts-field')] = $(@).parent().parent().data($(@).data('ts-field'))
      data['parent_id'] = $(@).data('ts-parent-id') if $(@).data('ts-parent-id') 
      console.log data
      $.ajax
        type: "POST"
        url: $(@).data('ts-new-url')
        dataType: 'json'
        contentType: 'application/json'
        data: JSON.stringify(data)
        success: (data, status) -> window.location.reload()
    .appendTo($li)
  $li.appendTo($ul)

  $ul

setUpDrops = (elements)->
  drops = []
  for element in elements
    drop = new Drop
      target: $(element)[0]
      content: buildFields(element)[0]
      position: 'bottom left'
      openOn: 'click'
      classes: 'drop-theme-arrows-bounce-dark'
    $(element).data('drop', drop)
    drops.push drop

  drops

class window.TS.NewModel
  constructor: (@elements) ->
    @drops = []

  enable: ->
    @disable()
    @drops = setUpDrops(@elements)

  disable: ->
    for drop in @drops
      drop.close()
      drop.remove()
      drop.destroy()
    @drops = []