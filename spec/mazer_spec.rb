require 'spec_helper'
require 'mazer'
#when spec helper changes paths like currently, 'require_relative 'mazer'' raises error

describe Mazer do

  context "can make a size one maze" do
    let (:maze){ Mazer.new(1) }
      it "whose size one maze has length of one" do
	expect(maze.maze_ary.flatten.length).to eq 1
      end
  end

  context "can make a 2 x 2 maze" do
    let (:maze){ Mazer.new(2) }
      it "that has 4 total indices" do
	expect(maze.maze_ary.flatten.length).to eq 4 
      end

      it "whose sets in first row reflect the index" do
	maze.maze_starter
	expect(maze.maze_ary[0]).to eq [0,1]
      end

      it "that passes set to second row at least once for different sets" do
	maze.maze_starter
	maze.inherit_set_from(row = 0)
	expect(maze.maze_ary[row]).to eq [0,1]
      end 

      it "that doesnt pass a set to second row if it doesnt exist in first row" do
	maze.maze_ary[0] = [0,0]
	maze.inherit_set_from(row = 0)
	expect(maze.maze_ary[row].count(1)).to eq 0
      end

      it "that can mark matching inheritance ary true if set needs to be inherited" do
	maze.maze_starter
	maze.assign_inheritance(row = 0)
	expect(maze.inheritance_ary[0]).to eq [true, true]
      end

    end

    context "can build a 3 x 3 maze" do
      let (:maze){ Mazer.new(3) }

      it "whose 2nd row will only inherit sets that match inheritance arrays marked true" do
	maze.maze_starter
	maze.inheritance_ary[0] = [true, false, true]
	maze.inherit_set_from(0)
	expect(maze.maze_ary[1]).to eq [0, nil, 2]
      end

      it "whose last row becomes all the same set" do
	maze.maze_starter
	[0,1].each { |row| 
	  maze.reset_row(row)
	  maze.assign_inheritance(row)
	  maze.inherit_set_from(row)
	}
	maze.final_row_reset
	expect(maze.maze_ary[2][0..1]).to eq maze.maze_ary[2][1..2]
      end

      #still so hard to figure out testing for random

      it "that will assign selected set ids to nil maze idxes" do
	maze.maze_starter
	maze.maze_ary[0][2] == nil
	maze.reset_row(0)
	expect(maze.maze_ary[0].include?(nil)).to eq false
      end

      it "that will inherit at least one per set" do
        maze.make_maze
        idx_inh = maze.inheritance_ary.each_with_index.map { |row, idx|
          row.each_index.select { |inh_idx|
            maze.inheritance_ary[idx][inh_idx]
           }.uniq
         }
	
        expect(maze.maze_ary.each_with_index.all? { |row, idx|
          idx_inh[idx].each.map { |tru_idx| row[tru_idx] }.uniq.sort == row.uniq.sort || idx == maze.maze_ary.length - 1 
         } ).to eq true
      end

      
    end

    context "can build a 10x10 maze" do
      let(:maze){ Mazer.new(10) } 

      it "that can do random shit" do
        maze.make_maze
        maze.print_maze_w_set
        maze.print_maze
      end

      it "how can i prevent sets from being the same as above?" do

      end

    end
end 
