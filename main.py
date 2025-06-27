import pyserial
import pygame

def main():
    try:
        # Attempt to open a serial port
        ser = pyserial.Serial('/dev/ttyUSB0', 115200, timeout=1)
        print("Serial port opened successfully.")
        
        # Close the serial port
        ser.close()
        print("Serial port closed successfully.")
    except pyserial.SerialException as e:
        print(f"Error opening serial port: {e}")


ser = pyserial.Serial('/dev/ttyUSB0', 115200, timeout=1)
    pygame.display.set_mode((640, 480))
    pygame.display.set_caption("Serial Port Monitor")