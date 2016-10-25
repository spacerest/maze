class Mazer

  attr_reader :maze_ary, :inheritance_ary

  def initialize(size)
    @maze_ary = Array.new(size) { Array.new(size) }
    @inheritance_ary = Array.new(size) { Array.new(size) {false} } 
    @size = size
  end

  def maze_starter
    @maze_ary[0] = @maze_ary[0].each_index.map { |idx| idx }
  end 

  def assign_inheritance(row)
    @maze_ary[row].uniq.each { |set_id|
      count_id = @maze_ary[row].count(set_id)
      num_inherit = rand(count_id) + 1
      idx_inherit = @maze_ary[row].each_index.select { |idx| 
        @maze_ary[row][idx] == set_id
      }
      idx_inherit.sample(1).each { |idx|
        @inheritance_ary[row][idx] = true
      }
    }
  end

  def inherit_set_from(row)
    @maze_ary[row + 1] =  @maze_ary[row].each_with_index.map { |set_id, idx| 
      @inheritance_ary[row][idx] ? set_id : nil
    }
  end

  def reset_row(row)
    set_id = 1
    last_idx = 0
    retain_idx = (1..(@size - 2)).to_a.shuffle.sample(rand(@size - 2) + 1).unshift(@size - 1)
    retain_idx.sort.each { |idx|
      (last_idx..idx).to_a.each { |idx_idx|
	@maze_ary[row][idx_idx] = set_id
      }
      set_id += 1
      last_idx = idx 
    } 
  end
 
  def final_row_reset
    @maze_ary[-1] = @maze_ary[-1].map { |set_id| 0 }
    @inheritance_ary[-1] = @inheritance_ary[-1].map { |x| false }
  end

  def make_maze
    self.maze_starter
    (0..(@maze_ary.length - 2)).to_a.each { |row|
      self.reset_row(row)
      self.assign_inheritance(row)
      self.inherit_set_from(row)
    }
    self.final_row_reset
  end

  def print_maze
    puts ""
    puts "_" * (@maze_ary.length) * 2 + "_"
    @maze_ary.each_with_index { |row, row_idx|
      print "|"
	row.each_with_index { |set_id, set_id_idx|
	  if @inheritance_ary[row_idx][set_id_idx]
	    print " "
      	    if set_id_idx == (@maze_ary.length - 1) || set_id != row[set_id_idx + 1]
      	      print "|" 
      	    else
      	      print " "
      	    end
	  else
	    print "_"
      	    if set_id_idx == (@maze_ary.length - 1) || set_id != row[set_id_idx + 1]
      	      print "|" 
      	    else
      	      print "_"
      	    end
	  end
      	}
      puts ""
     }
  end


  def print_maze_w_set
    puts ""
    @maze_ary.each_with_index { |row, row_idx|
      row.each_with_index { |set_id, set_id_idx|
	print "#{set_id || "x"}"
      }
      puts ""
     }
  end
end
