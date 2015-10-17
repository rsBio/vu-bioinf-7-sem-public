program ŽIRGAS;
const N
= 5;
{Šachmatų lentos dydis}
NN
= 25;
{Langelių skaičius šachmatų lentoje 5x5}
type INDEX = 1..N;
var
LENTA : array[INDEX, INDEX] of integer; {Globali duomenų bazė}
CX, CY : array[1..8] of integer; {Produkcijų aibė visada iš 8 prod.}
I, J
: integer;
YRA
: boolean;
procedure INICIALIZUOTI;
var
I, J : integer
begin
{1) Suformuojama produkcijų aibė}
CX[1] := 2;
CY[1] := 1;
CX[2] := 1;
CY[2] := 2;
CX[3] := -1;
CY[3] := 2;
CX[4] := -2;
CY[4] := 1;
CX[5] := -2;
CY[5] := -1;
CX[6] := -1;
CY[6] := -2;
CX[7] := 1;
CY[7] := -2;
CX[8] := 2;
CY[8] := -1;
{2) Inicializuojama globali duomenų bazė}
for I := 1 to N do
for J := 1 to N do
LENTA[I, J] := 0;
end; {INICIALIZUOTI}
procedure EITI (L : integer; X, Y : INDEX; var YRA : boolean);
{Įėjimo parametrai L – ėjimo numeris; X, Y – paskutinė žirgo padėtis}
{Išėjimo parametras (t.y. rezultatas) YRA}
var
K
: integer; {Produkcijos eilės numeris}
U, V : integer; {Nauja žirgo padėtis}
begin
K := 0;
repeat {Perrenkamos produkcijos iš 8 produkcijų aibės}
K := K + 1;
U := X + CX[K]; V := Y + CY[K];
{Patikrinama, ar duomenų bazė tenkina produkcijos taikymo sąlygą}
if (U >= 1) and (U <= N) and (V >= 1) and (V <= N)
then {Neišeinama už lentos krašto.}
{Patikrinama, ar langelis laisvas, t. y. ar žirgas jame nebuvo}
if LENTA[U, V] = 0
then
begin
{Nauja žirgo pozicija pažymima ėjimo numeriu}
LENTA[U, V] := L;
{Patikrinama, ar dar ne visa lenta apeita}
if L < NN
then
begin {Jeigu lenta neapeita, tai bandoma daryti ėjimą}
EITI(L+1, U, V, YRA);
{Jei buvo pasirinktas nevedantis į sėkmę ėjimas,}
{tai grįžtama atgal, t. y. langelis atlaisvinamas}
if not YRA then LENTA[U, V] := 0;
end
else YRA := true; {Kai L=NN}
end;
until YRA or (K = 8); {Sėkmė arba perrinktos visos 8 produkcijos}
end; {EITI}
begin {Pagrindinė programa (main program)}
{1. Paruošiama globali duomenų bazė ir užpildoma produkcijų aibė}
INICIALIZUOTI; YRA := false;
{2. Pažymima pradinė žirgo padėtis: langelis [1,1]}
LENTA [1, 1] := 1;
{3. Kviečiama procedūra sprendinio paieškai. Daryti antrą ėjimą, }
{
stovint langelyje X=1 ir Y=1, ir gauti atsakymą YRA
}
EITI(2, 1, 1, YRA);
{4. Jeigu sprendinys rastas, tai spausdinama lenta}
if YRA then
for I := N downto 1 do
begin
for J := 1 to N do
write(LENTA[I,J]);
writeln;
end;
else writeln('Sprendinys neegzistuoja');
end.
