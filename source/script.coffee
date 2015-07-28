$ ->
  # keeps track of where we are in our paginated api calls
  indexCount = 0

  # loadData takes an offset and gets paginated data from ajax api call
  loadData = (offset) ->
    $('#posts').append '<div class=post id=loading-message>Loading...</div>'
    
    # set a constant for the number of items to use for pagination
    quantity = 15
    
    # make the ajax call for data based on quantity and offset
    $.getJSON 'http://www.stellarbiotechnologies.com/media/press-releases/json' + 
    "?limit=#{quantity}&offset=#{offset * quantity}", (data) ->
    
      # only add new items if there are new items returned
      if data.news.length
      
        # once we have data from the call, remove the loading message
        $('#loading-message').fadeOut 100, ->
          $(this).remove()
          
          # initial state of new items to add is empty
          html = ''

          # loop through news items and build html string
          for item, index in data.news
            html += """
            <article style='animation-delay: #{(index + 1) * 100}ms' class='post'>
              <h2>#{item.title}</h2>
              <time datetime='#{item.published}'>
                #{moment(item.published).format('MMMM Do, YYYY')}
              </time>
            </article>
            """

          # append the html string to the page
          $('#posts').append html
          
          # increment the index count
          indexCount++
          
          # call the postWatcher function to watch for the end of the posts
          postWatcher()

      # if there are no new items, tell the user
      else
        $('#loading-message').text 'All posts have been loaded'

  # postWatcher sets up a waypoint and listener
  postWatcher = (done) ->
    
    # add a div to listen for after #posts
    $('#posts').after '<div id="load-more"></div>'

    # Listen for #load-more near viewport bottom, call loadData, destroy waypoint
    $('#load-more').waypoint (direction) ->
      loadData indexCount
      this.destroy()

    # 120% from the viewport top = 20% away from the bottom of the viewport
    , offset: '120%'

  # Load initial data, setup watcher/load loop until no more data
  loadData 0
