from data_treatment import Modelo
from serial_reader import SerialReader

modelo = Modelo()
serial_reader = SerialReader('/dev/ttyUSB0', 115200, modelo)
serial_reader.read_serial()