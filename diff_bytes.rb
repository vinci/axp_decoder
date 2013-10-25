#! /usr/bin/ruby

READ_SIZE = 65536

def diff_bytes(filename1, filename2)
  file1 = File.new filename1
  file2 = File.new filename2
  common = []
  diff = []
  t1 = []
  t2 = []
  READ_SIZE.times do
    b1 = file1.getbyte
    b2 = file2.getbyte
    if b1 == b2
      if !t2.empty?
        diff << t2
        t2 = []
      end
      t1 << b1
    else
      if !t1.empty?
        common << t1
        t1 = []
      end
      t2 << [b1,b2]
    end
  end
  return common,diff
end

def hex(fixnum)
  return fixnum.to_s(16)
end

def put_xml_elem(tagname, val)
  return "<#{tagname}>#{val}</#{tagname}>"
end

def a_to_hex(array)
  s = ''
  t = ''
  for e in array
    t = hex(e)
    if 1 == t.length
      t = "0"+t
    end
    s += t
  end
  return s
end

def get1(a)
  n = []
  for e in a
    n << e[0]
  end
  return n
end

def get2(a)
  n = []
  for e in a
    n << e[1]
  end
  return n
end

def main()
  if ARGV.length < 2
    exit 1
  end
  common,diff = diff_bytes(ARGV[0], ARGV[1])
  (common.length).times do |i|
  puts put_xml_elem("c#{i}", a_to_hex(common[i]))
  puts put_xml_elem("d#{i}", a_to_hex(get1(diff[0]))+","+a_to_hex(get2(diff[0])))
  end
end

main
