# encoding: UTF-8
require 'pp'
require 'csv'

MatrixSize = 20
Uebersetzungen = [["Sommer", "Vasara"],
             ["Sonne",	"Sv"],
             ["Garten",	"Darzs"],
             ["Meer",	"Jura"],
             ["Blumen",	"Zieds"],
             ["Strand", "Pludmale"],
             ["See",	"Ezers"],
             ["Urlaub",	"Atvalinajums"],
             ["Sandalen",	"Sandales"],
             ["Baden",	"peldeties"],
             ["Ball",	"Bumba"],
             ["Schwimmen",	"pellet"],
             ["Heiß",	"Karsts"],
             ["Ferien",	"Brivdienas"],
             ["Schatten",	"ENA"],
             ["Spaziergang",	"staigat"],
             ["Getränke",	"dzerieniem"],
             ["Sand",	"Smiltis"],
             ["Sonnenbrille",	"saulesbrilles"],
             ["Sonnenschirm",	"saulessargs"],
             ["Creme",	"Krems"]
            ]

$matrix = Array.new(MatrixSize){Array.new(MatrixSize,' ')}
worte = Uebersetzungen.map { |n| n[1] }.sort { |a, b| b.length <=> a.length }

pp worte

def print_matrix(matrix)

  puts "Matrix"
  puts "         1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0"
  i = 0
  matrix.each do |zeile|
    i += 1
    print "Zeile #{'%2d' % i}"
    zeile.each do |zelle|
      print " #{zelle}"
    end
    puts
  end
end

def save_matrix(matrix, worte)
  CSV.open("myfile.csv", "w") do |csv|
    csv << ["Wörterrätsel deutsch"]
    csv << ["\n"]
    matrix.each do |zeile|
      csv << zeile
    end
    csv << ["\n"] 
    worte.each do |wort|
      csv << [wort] 
    end
  end
end

def setze_wort_hor(wort, matrix)

  def ermittle_positionen_hor(wort, matrix)
    w = wort.length
    ziel = []
    i = 0
    matrix.each do |zeile|
      j = 0
      zeile.each do |zelle|
        if j + w <= MatrixSize
          moeglich = true
          x = j 
          w.times do
            # puts "1 #{wort} #{x} #{i} #{wort[x-j,1].upcase}"
            if matrix[i][x] != " " && matrix[i][x] != wort[x-j,1].upcase
              moeglich = false
            end
            x += 1
          end
          if moeglich
            ziel << [i,j]
          end
        end
        j += 1
      end
      i += 1
    end
    return ziel
  end

  def setze_wort_matrix_hor(wort, matrix, pos)
    i = 0
    wort.length.times do 
      matrix[pos[0]][pos[1]+i] = wort[i].upcase
      i += 1
    end  
  end

  ziel = ermittle_positionen_hor(wort, matrix)
  position = rand(ziel.length)
  setze_wort_matrix_hor(wort, matrix, ziel[position])
  
end

def setze_wort_ver(wort, matrix)

  def ermittle_positionen_ver(wort, matrix)
    w = wort.length
    ziel = []
    i = 0
    matrix.each do |zeile|
      j = 0
      zeile.each do |zelle|
        if i + w <= MatrixSize
          moeglich = true
          x = i 
          w.times do
            # puts "2 #{wort} #{x} #{i} #{wort[x-i,1].upcase}"
            if matrix[x][j] != " " && matrix[x][j] != wort[x-i,1].upcase
              moeglich = false
            end
            x += 1
          end
          if moeglich
            ziel << [i,j]
          end
        end
        j += 1
      end
      i += 1
    end
    return ziel
  end

  def setze_wort_matrix_ver(wort, matrix, pos)
    i = 0
    wort.length.times do 
      matrix[pos[0]+i][pos[1]] = wort[i].upcase
      i += 1
    end  
  end

  ziel = ermittle_positionen_ver(wort, matrix)
  position = rand(ziel.length)
  setze_wort_matrix_ver(wort, matrix, ziel[position])
  
end

def leerstellen_fuellen(matrix)
  i = 0
  matrix.each do |zeile|
    j=0
    zeile.each do |stelle|
      if stelle == " "
        matrix[i][j] = [*'A'..'Z'][rand(24)]
      end
      j += 1
    end
    i += 1
  end
end

# --- Main -------------------------------

puts "Wörterrätsel"
puts

worte.each do |wort|
  if rand(2) == 0
    setze_wort_hor(wort, $matrix) 
  else
    setze_wort_ver(wort, $matrix)
  end
end

# leerstellen_fuellen($matrix)
print_matrix($matrix)
# save_matrix($matrix, Uebersetzungen.map { |n| n[0] })
