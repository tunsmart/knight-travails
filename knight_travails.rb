require 'pry-byebug'
MOVE_OFFSETS = [[-1,-2],[1,-2],
                [-2,-1], [2,-1],
                [-2,1], [2,1],
                [-1,2], [1,2]
]

def build_graph
    board = []
    for row in 0..7 do
        for column in 0..7 do
            square = [row,column]
            board << square
        end
    end

    graph = {}
    i = 0
    board.each{|square|
        arr = []
        legal_moves_from(square) {|move_square|
            arr << move_square
        }
        graph[square] = arr
    }
    graph
end

def legal_moves_from(square)
    MOVE_OFFSETS.each{|offset_arr|
        legal_row = square[0] + offset_arr[0]
        legal_col = square[1] + offset_arr[1]
        yield [legal_row, legal_col] if legal_row.between?(0, 7) && legal_col.between?(0, 7) 
    }
end

class VertexProperties
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
    for i in 0...keys.length do
        bfs_info[keys[i]] = VertexProperties.new
    end
    bfs_info[source].distance = 0
    queue = []
    queue << source
    until queue.empty?
        vertex = queue[0]
        
        to_queue = graph[vertex]
        until to_queue.empty?
            #binding.pry
            if bfs_info[to_queue[0]].distance.nil?
                bfs_info[to_queue[0]].predecessor = vertex 
                bfs_info[to_queue[0]].distance = bfs_info[vertex].distance + 1
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
    #binding.pry
    puts "You made it in #{steps} steps"
    puts "Here is your path"
    find_path(end_square, search).each {|path| p path}
end

def find_path(square, search)
    result = []
    vertex = square
    until search[vertex].predecessor.nil?
        result << vertex
        vertex = search[vertex].predecessor
    end
    result << vertex
    result.reverse!
end


#moves.each{|key,value| puts "#{key}, #{value}"}
#info = do_bfs(moves, [0,0])
#info.each do |key, value|
#    puts "vertex: #{key}, distance: #{value.distance}, predecessor: #{value.predecessor}"
#end

knight_move([0,0],[3,3])