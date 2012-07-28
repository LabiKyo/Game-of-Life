WIDTH = 80
HEIGHT = 80
INTERVAL = 1000
MAX_TICK = 1000

DIRECTION = [
  x: -1, y: -1
,
  x: -1, y: 0
,
  x: -1, y: 1
,
  x: 0, y: -1
,
  x: 0, y: 1
,
  x: 1, y: -1
,
  x: 1, y: 0
,
  x: 1, y: 1
]

map = []
map[0] = []
current_step = 0
interval_id = null

$ ->
  # init canvas and data
  canvas = document.createElement 'div'
  canvas.id = 'canvas'
  canvas.className = 'grid'

  row_div = document.createElement 'div'
  row_div.className = 'row'

  cell_div = document.createElement 'div'
  cell_div.className = 'cell'

  for row in [0...HEIGHT]
    map[0][row] = get_filled_array(WIDTH, false)
    row_cloned = row_div.cloneNode()
    row_cloned.id = row
    canvas.appendChild row_cloned
    for col in [0...WIDTH]
      cell_cloned = cell_div.cloneNode()
      cell_cloned.id = "#{row}-#{col}"
      cell_cloned.dataset.row = row
      cell_cloned.dataset.col = col
      row_cloned.appendChild cell_cloned

  document.body.appendChild canvas
  make_cell_live(1, 1)
  make_cell_live(1, 2)
  make_cell_live(1, 3)

  # event binding
  $('#canvas').on 'click', '.cell', (e) ->
    cell = e.currentTarget
    make_cell_live(cell.dataset.row, cell.dataset.col)

  $('#start').on 'click', start
  $('#stop').on 'click', stop
  $('#next').on 'click', next_step

# utils
make_cell_live = (row, col) ->
  unless map[current_step][row][col] # cell is dead
    map[current_step][row][col] = true
    cell = document.getElementById "#{row}-#{col}"
    cell.classList.add 'live'

make_cell_dead = (row, col) ->
  if map[current_step][row][col] # cell is live
    map[current_step][row][col] = false
    cell = document.getElementById "#{row}-#{col}"
    cell.classList.remove 'live'

next_step = ->
  sum = []
  i = HEIGHT
  while (i--)
    a = get_filled_array(WIDTH, 0)
    sum.push(a)

  current = map[current_step]
  ++current_step
  map[current_step] = $.extend(true, [], current)

  # count sum
  for row, i in current
    for cell, j in row
      if cell
        for dir in DIRECTION
          ++sum[i+dir.y]?[j+dir.x]

  for row, i in current
    for cell, j in row
      cell_sum = sum[i][j]
      if cell # current live
        unless 2 <= cell_sum <= 3
          make_cell_dead(i, j)
      else # current dead
        if cell_sum is 3
          make_cell_live(i, j)

  false

start = ->
  if interval_id is null
    interval_id = setInterval next_step, INTERVAL
  false

stop = ->
  clearInterval interval_id
  interval_id = null
  false

get_filled_array = (length, value) ->
  array = []
  while length--
    array.push value
  array
