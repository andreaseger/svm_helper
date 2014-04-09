require 'benchmark'

p "#{RUBY_ENGINE} #{RUBY_VERSION}"
text = DATA.read
n = 20_000

Benchmark.bmbm do |x|
  x.report("split+reject") do
    n.times do
      text.split(/\W/).reject(&:empty?) 
    end
  end

  x.report("scan") do
    n.times do
      text.scan(/\w+/)
    end
  end
end

__END__

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum feugiat
varius sapien tincidunt adipiscing. Curabitur ac massa facilisis, mattis leo in,
interdum purus. Pellentesque non urna non leo dictum adipiscing sed interdum
diam. Aliquam sit amet velit eu risus vehicula varius. Praesent ultrices sapien
vel magna mollis, laoreet vulputate ligula rhoncus. Quisque faucibus lectus a
diam fermentum vestibulum. Praesent felis massa, bibendum vel diam et, accumsan
convallis nibh. Integer a varius tellus. Praesent laoreet, elit id lacinia
commodo, turpis enim aliquet magna, in sagittis metus mi in leo. Curabitur
libero dui, condimentum a tortor ut, euismod adipiscing odio. Fusce sagittis
lorem lobortis, faucibus erat in, laoreet lorem. Nunc venenatis pulvinar sapien
ut egestas. Pellentesque habitant morbi tristique senectus et netus et malesuada
fames ac turpis egestas. Proin sollicitudin id justo et fermentum. Fusce
tincidunt consequat dolor, nec fringilla nisi. Praesent interdum massa iaculis
hendrerit ultricies. Class aptent taciti sociosqu ad litora torquent per conubia
nostra, per inceptos himenaeos. Maecenas vehicula euismod mauris vitae vehicula.
Morbi consectetur justo vitae urna cursus mollis. Vestibulum bibendum volutpat
metus. Sed sed metus id libero tristique semper et ut odio. Aenean et nisi id
mauris fermentum scelerisque non et velit. Ut accumsan sem eu felis faucibus
tincidunt. Pellentesque eget aliquam lectus. Mauris convallis nunc metus,
dignissim placerat erat imperdiet ac. Donec dignissim purus sit amet est
tristique, et aliquam justo porttitor. Integer quis lacus ipsum. Aenean at ipsum
mauris. Nulla hendrerit felis eu dolor lobortis, convallis accumsan dui
accumsan. Quisque dictum, nisl sed adipiscing consectetur, augue nisi dapibus
ante, quis mollis nisl eros at nibh. In aliquam ultricies tincidunt. Praesent
vulputate tortor nec lacus pretium, bibendum porttitor nisl venenatis. Curabitur
ut libero sit amet felis elementum fermentum. In hac habitasse platea dictumst.
Nunc commodo lorem sed ipsum faucibus viverra. Donec vestibulum consectetur
ligula ac tincidunt. Donec sit amet metus mauris. Vivamus at justo accumsan,
porttitor justo eu, porta felis. Phasellus tempus arcu in mauris dapibus
vehicula. Duis sed varius libero. Pellentesque vitae felis libero. Nulla
facilisi. Mauris tempor enim nec erat molestie suscipit. Aenean dictum fringilla
purus, vel ultricies dui dapibus sed. Pellentesque habitant morbi tristique
senectus et netus et malesuada fames ac turpis egestas. Ut facilisis erat et
molestie ullamcorper. Suspendisse vel elit et diam tincidunt dictum. Etiam
tempus massa ac cursus euismod. Suspendisse quis est non tortor semper
tristique. Sed aliquam, eros sed convallis euismod, elit enim sodales eros, quis
iaculis dui lorem sit amet odio. Proin vel sodales leo. Fusce porta, neque nec
auctor ultrices, tortor erat volutpat turpis, in ultricies nisl arcu a lacus.
Aliquam posuere mollis justo, quis egestas ipsum luctus quis. Donec elementum
leo metus, non bibendum lacus ornare ut. Donec et orci sit amet libero auctor
iaculis. Proin vel aliquam orci. Interdum et malesuada fames ac ante ipsum
primis in faucibus.
