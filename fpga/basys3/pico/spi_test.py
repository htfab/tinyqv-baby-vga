import machine, struct

cs = machine.Pin(17, machine.Pin.OUT)
sck = machine.Pin(18, machine.Pin.OUT)
mosi = machine.Pin(19, machine.Pin.OUT)
miso = machine.Pin(16, machine.Pin.IN)

useSoftSpi = False

if useSoftSpi:
    spi = machine.SoftSPI(
                  baudrate=10,
                  polarity=0,
                  phase=0,
                  bits=8,
                  firstbit=machine.SPI.MSB,
                  sck=sck,
                  mosi=mosi,
                  miso=miso)
else:
    spi = machine.SPI(0,
                  baudrate=1000000,
                  polarity=0,
                  phase=0,
                  bits=8,
                  firstbit=machine.SPI.MSB,
                  sck=sck,
                  mosi=mosi,
                  miso=miso)

def write_reg(address, value):
    cs.value(0)
    spi.write(b'\xC0\x00\x00' + struct.pack('>B', address) + struct.pack('>L', value))
    cs.value(1)

def read_reg(address):
    cs.value(0)
    spi.write(b'\x40\x00\x00' + struct.pack('>B', address))
    res, = struct.unpack('>L', spi.read(4))
    cs.value(1)
    return res

write_reg(0, 0x01234567)
write_reg(4, 0x12345678)
print(hex(read_reg(0)))
print(hex(read_reg(4)))
print(hex(read_reg(8)))
print(hex(read_reg(12)))

for i in range(16): write_reg(i*4, 0x11111111*i)
