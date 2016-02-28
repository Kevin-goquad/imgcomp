#-------------------------------------------------------------
# imgcomp makefile for Linux (compile on raspberry pi or pi2)
# Matthias Wandel 2015
#-------------------------------------------------------------
OBJ=obj
SRC=src
CFLAGS:= $(CFLAGS) -O3 -Wall

all: objdir imgcomp blink_camera_led

objdir:
	@mkdir -p obj

objs = $(OBJ)/main.o $(OBJ)/compare.o $(OBJ)/jpeg2mem.o \
	$(OBJ)/jpgfile.o $(OBJ)/exif.o $(OBJ)/start_raspistill.o $(OBJ)/util.o

$(OBJ)/jpgfile.o $(OBJ)/exif.o $(OBJ)/start_raspistill.o: $(SRC)/jhead.h

$(OBJ)/%.o:$(SRC)/%.c $(SRC)/imgcomp.h
	${CC} $(CFLAGS) -c $< -o $@

imgcomp: $(objs) libjpeg/libjpeg.a
	${CC} -o imgcomp $(objs) libjpeg/libjpeg.a

$(SRC)/pi_model.h:
	$(SRC)/identify_pi >> $(SRC)/pi_model.h

blink_camera_led: $(SRC)/blink_camera_led.c $(SRC)/pi_model.h
	$(CC) -o blink_camera_led $(SRC)/blink_camera_led.c

libjpeg/libjpeg.a:
	cd libjpeg; make


clean:
	rm -f $(objs) imgcomp

