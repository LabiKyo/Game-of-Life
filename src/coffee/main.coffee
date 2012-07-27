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
    map[0][row] = []
    row_cloned = row_div.cloneNode()
    row_cloned.id = row
    canvas.appendChild row_cloned
    for col in [0...WIDTH]
      map[0][row][col] = false
      cell_cloned = cell_div.cloneNode()
      cell_cloned.id = "#{row}-#{col}"
      cell_cloned.dataset.row = row
      cell_cloned.dataset.col = col
      row_cloned.appendChild cell_cloned

  document.body.appendChild canvas
  make_cell_live(1, 1)
  make_cell_live(1, 2)
  make_cell_live(1, 3)
  setInterval next_step, INTERVAL

  # event binding
  $('#canvas').on 'click', '.cell', (e) ->
    cell = e.currentTarget
    make_cell_live(cell.dataset.row, cell.dataset.col)

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
  current = map[current_step]
  ++current_step
  map[current_step] = $.extend(true, [], current)
  for row, i in current
    for cell, j in row
      sum = 0
      for dir in DIRECTION
        if current[i + dir.y]?[j + dir.x]
          ++sum
      if cell # current live
        unless 2 <= sum <= 3
          make_cell_dead(i, j)
      else # current dead
        if sum is 3
          make_cell_live(i, j)
