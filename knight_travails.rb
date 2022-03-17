# frozen_string_literal: true

# offsets to ensure knight moves don't go offboard
MOVE_OFFSETS = [[-1, -2], [1, -2],
                [-2, -1], [2, -1],
                [-2, 1], [2, 1],
                [-1, 2], [1, 2]].freeze

def build_graph
  board = []
  (0..7).each do |row|
    (0..7).each do |column|
      square = [row, column]
      board << square
    end
  end

  graph = {}
  i = 0
  board.each do |square|
    arr = []
    legal_moves_from(square) do |move_square|
      arr << move_square
    end
    graph[square] = arr
  end
  graph
end

# uses the offsets to determine legal moves and only yields that to the graph builder
def legal_moves_from(square)
  MOVE_OFFSETS.each do |offset_arr|
    legal_row = square[0] + offset_arr[0]
    legal_col = square[1] + offset_arr[1]
    yield [legal_row, legal_col] if legal_row.between?(0, 7) && legal_col.between?(0, 7)
  end
end

class NodeProperties
  attr_accessor :distance, :predecessor

  def initialize
    distance = nil
    predecessor = nil
  end
end

def do_bfs(source)
  graph = build_graph
  bfs_info = {}
  keys = graph.keys
  (0...keys.length).each do |i|
    bfs_info[keys[i]] = NodeProperties.new
  end
  bfs_info[source].distance = 0
  queue = []
  queue << source
  until queue.empty?
    node = queue[0]

    to_queue = graph[node]
    until to_queue.empty?
      if bfs_info[to_queue[0]].distance.nil?
        bfs_info[to_queue[0]].predecessor = node
        bfs_info[to_queue[0]].distance = bfs_info[node].distance + 1
        queue << to_queue.shift
      else
        to_queue.shift
      end
    end
    queue.shift
  end
  bfs_info
end

def knight_move(start_square, end_square)
  search = do_bfs(start_square)
  steps = search[end_square].distance
  # binding.pry
  puts "You made it in #{steps} steps"
  puts 'Here is your path'
  find_path(end_square, search).each { |path| p path }
end

def find_path(square, search)
  result = []
  node = square
  until search[node].predecessor.nil?
    result << node
    node = search[node].predecessor
  end
  result << node
  result.reverse!
end

# moves.each{|key,value| puts "#{key}, #{value}"}
# info = do_bfs(moves, [0,0])
# info.each do |key, value|
#    puts "node: #{key}, distance: #{value.distance}, predecessor: #{value.predecessor}"
# end

knight_move([0, 0], [3, 3])
