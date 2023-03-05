REM Two Body Problem
'_FULLSCREEN
RANDOMIZE TIMER
SCREEN 12
DEFDBL A-Z

DIM win(2, 2)
win(1, 1) = -100
win(1, 2) = -100
win(2, 1) = 100
win(2, 2) = 100

WINDOW (win(1, 1), win(1, 2))-(win(2, 1), win(2, 2))

G = 6.67
L = 3000
DIM m(3)
DIM x(3, 2)
DIM v(3, 2)
DIM a(3, 2)
DIM paths(3, L, 2)
DIM c(3)


WHILE 1
    _KEYCLEAR
    LOCATE 7, 22
    COLOR 14: PRINT "Welcome to orbital mechanics simulator!"
    LOCATE 14, 17
    COLOR 12: PRINT "Press 1 for a simulation of two objects falling"
    LOCATE 15, 23
    PRINT "towards each other in empty space."
    LOCATE 17, 4
    COLOR 11: PRINT "Press 2 for a simulation of an object orbiting a much more massive object."
    LOCATE 19, 10
    COLOR 10: PRINT "Press 3 for a simulation of two objects orbiting one another."
    'LOCATE 19, 9
    'COLOR 6: PRINT "Press 4 for a simulation of three objects orbiting one another."
    LOCATE 21, 33
    COLOR 7: PRINT "Press 4 to quit."
    SLEEP
    c$ = INKEY$
    CLS
    IF c$ = "1" THEN
        GOSUB simulation1
    ELSEIF c$ = "2" THEN
        GOSUB simulation2
    ELSEIF c$ = "3" THEN
        GOSUB simulation3
        'ELSEIF c$ = "4" THEN
        '    GOSUB simulation4
    ELSEIF c$ = "4" THEN END
    END IF

WEND

simulation1:

REM First demo
REM Two objects with 0 velocity in empty space

dt = 0.00005
m1 = 900 * RND(1) + 100
m2 = 900 * RND(1) + 100
v1i = 0
v2i = 0
ri = 100

v1 = v1i
v2 = v2i
x1 = -ri / 2
x2 = ri / 2
r = ri
t = 0

CIRCLE (x1, -20), 10, 8
CIRCLE (x2, -20), 10, 14

LOCATE 2, 22
COLOR 12: PRINT "TWO OBJECTS FALLING TOWARD ONE ANOTHER"
SLEEP
LOCATE 5, 4
COLOR 8: PRINT USING "Object 1 has a mass of ###.## kg."; m1
LOCATE 5, 45
COLOR 14: PRINT USING "Object 2 has a mass of ###.## kg."; m2
SLEEP
LOCATE 8, 14
COLOR 12: PRINT "Calculate Fg if the distance between the two is"; ri; "m."
SLEEP
F = G * m1 * m2 / ri ^ 2
LOCATE 10, 28
PRINT USING "Fg = ####.## * 10 ^ -11 N."; F
SLEEP
LOCATE 13, 24
COLOR 8: PRINT "Now, let's watch";: COLOR 14: PRINT " them collide!"
COLOR 12
SLEEP
CLS
LOCATE 2, 22
COLOR 12: PRINT "TWO OBJECTS FALLING TOWARD ONE ANOTHER"

'_PALETTECOLOR 1, _RGB32(0, 0, 0)


WHILE ABS(r) > 0.1

    F = G * m1 * m2 / r ^ 2

    a1 = F / m1
    a2 = -F / m2

    dv1 = a1 * dt
    v1 = v1 + dv1

    dv2 = a2 * dt
    v2 = v2 + dv2

    dx1 = v1 * dt
    x1 = x1 + dx1

    dx2 = v2 * dt
    x2 = x2 + dx2

    r = ABS(x2 - x1)

    t = t + dt

    CIRCLE (ox1, 0), 10, 0
    CIRCLE (ox2, 0), 10, 0

    CIRCLE (x1, 0), 10, 8
    CIRCLE (x2, 0), 10, 14

    LOCATE 10, 32
    COLOR 12: PRINT USING "Time Elapsed: ##.##"; t

    ox1 = x1
    ox2 = x2

WEND

LOCATE 6, 16
COLOR 8: PRINT "Object 1";: COLOR 12: PRINT " and ";: COLOR 14: PRINT "Object 2";: COLOR 12: PRINT USING " collided after ##.## seconds."; t
SLEEP

CLS
RETURN

simulation2:

REM Second demo
REM An object orbiting a stationary object/point mass, in reality the second object would also rotate but I ignore that here, that is demo 3

dt = 0.00001
m2 = 500 * RND(1) + 400
r = 50
vyi = (m2 * G / r) ^ (1 / 2)
vx = 0
x = 50
y = 0
theta = 0
xc = 0
yc = 0
uppert = 50

CIRCLE (xc, yc - 60), 10, 1
PAINT (xc, yc - 60), 1
PSET (50, -60)

LOCATE 2, 22
COLOR 11: PRINT "AN OBJECT ORBITING A MUCH LARGER ONE"
SLEEP
LOCATE 5, 15
COLOR 8: PRINT USING "The large object has a mass of ###.## * 10 ^ 11 kg."; m2
LOCATE 7, 14
COLOR 14: PRINT USING "The orbiting object has a mass of ###.## * 10 ^ 4 kg."; 100 * RND(1) + 100
SLEEP
LOCATE 10, 8
COLOR 11: PRINT "Calculate the centripetal acceleration and orbital velocity"
LOCATE 11, 5
PRINT "of the orbiting object if the distance between the two objects is"; r; "m."
SLEEP
ac = G * m2 / r ^ 2
LOCATE 13, 32
PRINT USING "ac = #.### m/s^2."; ac
LOCATE 15, 30
PRINT USING "v_orb = ##.### m/s."; vyi
SLEEP
LOCATE 18, 10
COLOR 15: PRINT "Now, let's have the small object orbit at orbital velocity."
LOCATE 19, 30
PRINT "What will happen?"
COLOR 11
SLEEP
CLS
LOCATE 2, 22
COLOR 11: PRINT "AN OBJECT ORBITING A MUCH LARGER ONE"
count = 0

CIRCLE (xc, yc), 10, 1
PAINT (xc, yc), 1
PSET (r, 0)
SLEEP

vy = vyi
1 FOR t = 0 TO uppert STEP dt
    ac = -G * m2 / r ^ 2

    dvx = ac * COS(theta) * dt
    dvy = ac * SIN(theta) * dt

    vx = vx + dvx
    vy = vy + dvy

    dx = vx * dt
    dy = vy * dt

    x = x + dx
    y = y + dy

    ds = (dx ^ 2 + dy ^ 2) ^ (1 / 2)
    dtheta = ds / r
    theta = theta + dtheta

    r = ((y + yc) ^ 2 + (x + xc) ^ 2) ^ (1 / 2)

    PSET (x, y)

NEXT t

IF count = 0 THEN
    LOCATE 4, 24
    COLOR 6: PRINT "The object is in a stable orbit."
    SLEEP
    LOCATE 26, 23
    PRINT "What if the velocity is too small?"
    SLEEP
    vy = vyi * 0.95
    r = 50
    vx = 0
    x = 50
    y = 0
    theta = 0
    uppert = 100
    count = 1
    GOTO 1
ELSEIF count = 1 THEN
    LOCATE 2, 22
    COLOR 11: PRINT "AN OBJECT ORBITING A MUCH LARGER ONE"
    LOCATE 28, 23
    COLOR 10: PRINT "What if the velocity is too large?"
    SLEEP
    vy = vyi * 1.05
    r = 50
    vx = 0
    x = 50
    y = 0
    theta = 0
    uppert = 110
    count = 2
    GOTO 1
END IF

LOCATE 6, 27
PRINT "These orbits are unstable."

LOCATE 2, 22
COLOR 11: PRINT "AN OBJECT ORBITING A MUCH LARGER ONE"

SLEEP
CLS
RETURN

simulation3:
REM Simulation of two objects orbiting one another

dt = 0.0025

FOR i = 1 TO 3
    m(i) = 0
    FOR d = 1 TO 2
        x(i, d) = 0
        v(i, d) = 0
        a(i, d) = 0
    NEXT d
NEXT i

c(1) = 8
c(2) = 14
c(3) = 15

uppert = 20
count = -1

disp_x = win(2, 1) - win(1, 1)
disp_y = win(2, 2) - win(1, 2)
CIRCLE (win(1, 1) + disp_x / 4, win(1, 2) + disp_y / 4), 8, c(1)
CIRCLE (win(1, 1) + 3 * disp_x / 4, win(1, 2) + disp_y / 4), 8, c(2)
PSET (win(1, 1) + disp_x / 2, win(1, 2) + disp_y / 4), c(3)

LOCATE 2, 24
COLOR 10: PRINT "TWO OBJECTS ORBITING ONE ANOTHER"
SLEEP
LOCATE 6, 8
COLOR 10: PRINT "What happens when both objects have masses of the same magnitude?"
LOCATE 9, 13
PRINT "Let's give both objects a mass of 5 * 10^12 kg to start."
m(1) = 5000
m(2) = 5000
LOCATE 12, 14
PRINT "Let's vary the velocities and see how the objects move."
SLEEP
CLS

x(1, 1) = -40
x(2, 1) = 40
x(1, 2) = -10
x(2, 2) = -10
x(3, 1) = 0
x(3, 2) = -10
v(1, 2) = 10
v(2, 2) = -10
r = 60

2
CIRCLE (x(1, 1), x(1, 2)), 8, c(1)
CIRCLE (x(2, 1), x(2, 2)), 8, c(2)
PSET (x(3, 1), x(3, 2)), c(3)

LOCATE 2, 24
COLOR 10: PRINT "TWO OBJECTS ORBITING ONE ANOTHER"
LOCATE 5, 31
PRINT "Predict the orbits!"
LOCATE 4, 4
COLOR 8: PRINT USING "m1 = #.## * 10^12 kg"; m(1) / 1000
LOCATE 6, 4
PRINT USING "v1 = (##.##, ##.##) m/s"; v(1, 1), v(1, 2)
LOCATE 4, 54
COLOR 14: PRINT USING "m2 = #.## * 10^12 kg"; m(2) / 1000
LOCATE 6, 54
PRINT USING "v2 = (##.##, ###.##) m/s"; v(2, 1), v(2, 2)
SLEEP

FOR stp = 1 TO L
    FOR d = 1 TO 2
        FOR i = 1 TO 3
            paths(i, stp, d) = x(i, d)
        NEXT i
    NEXT d
NEXT stp


ticks = 1
FOR t = 0 TO uppert STEP dt

    FOR i = 1 TO 2
        ac = G * m(3 - i) / r ^ 2
        a(i, 1) = ac * (x(3 - i, 1) - x(i, 1)) / r
        a(i, 2) = ac * (x(3 - i, 2) - x(i, 2)) / r
    NEXT i

    FOR i = 1 TO 2
        FOR d = 1 TO 2
            v(i, d) = v(i, d) + a(i, d) * dt
            x(i, d) = x(i, d) + v(i, d) * dt
        NEXT d
    NEXT i
    x(3, 1) = (m(1) * x(1, 1) + m(2) * x(2, 1)) / (m(1) + m(2))
    x(3, 2) = (m(1) * x(1, 2) + m(2) * x(2, 2)) / (m(1) + m(2))

    r = SQR((x(1, 1) - x(2, 1)) ^ 2 + (x(1, 2) - x(2, 2)) ^ 2)

    ptr = ticks MOD L + 1

    FOR i = 1 TO 3
        PSET (paths(i, ptr, 1), paths(i, ptr, 2)), 0
        paths(i, ptr, 1) = x(i, 1)
        paths(i, ptr, 2) = x(i, 2)
    NEXT i

    FOR i = 1 TO 2
        last = ptr - 1 + ((ptr - 1 > 0) + 1) * 100
        CIRCLE (paths(i, last, 1), paths(i, last, 2)), 8, 0
        CIRCLE (paths(i, ptr, 1), paths(i, ptr, 2)), 8, c(i)
    NEXT i

    FOR i = 1 TO 3
        FOR p = ptr + 1 TO ptr + L
            tmp_p = p MOD L + 1
            PSET (paths(i, tmp_p, 1), paths(i, tmp_p, 2)), c(i)
        NEXT p
    NEXT i

    ticks = ticks + 1

NEXT t

count = count + 1

IF count = 0 THEN
    LOCATE 26, 22
    COLOR 10: PRINT "Now let's try different velocities."
    SLEEP
    CLS

    x(1, 1) = -40
    x(2, 1) = 40
    x(1, 2) = -10
    x(2, 2) = -10
    x(3, 1) = 0
    x(3, 2) = -10
    v(1, 1) = -2 + 2 * RND
    v(1, 2) = 6 * RND
    v(2, 1) = 0.5 + 2 * RND
    v(2, 2) = -(4 + 3 * RND)
    r = 60
    GOTO 2

ELSEIF count = 1 THEN
    LOCATE 26, 15
    COLOR 10: PRINT "Harder, right?  Did you see the center of mass move?"
    SLEEP
    CLS

    m(1) = 6500 + 2000 * RND
    m(2) = 2000 + 1000 * RND
    x(1, 1) = -40
    x(2, 1) = 40
    x(1, 2) = -10
    x(2, 2) = -10
    x(3, 1) = (m(1) * x(1, 1) + m(2) * x(2, 1)) / (m(1) + m(2))
    x(3, 2) = -10
    v(1, 1) = -1 + RND
    v(1, 2) = 3 + 3 * RND
    v(2, 1) = -4 + 2 * RND
    v(2, 2) = -(8.5 + 4 * RND)
    r = 60
    GOTO 2
END IF

LOCATE 26, 11
COLOR 10: PRINT "Lots of interesting motion can happen between two planets!"

SLEEP
CLS
RETURN

'simulation4:

'CLS
'RETURN
























