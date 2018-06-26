(deffacts Ciudad

(Camino A B 10 Ambos)
(Camino A C 8 Andando)
(Camino A E 10 Ambos)

(Camino B A 10 Ambos)
(Camino B C 5 Andando)
(Camino B F 6 Andando)

(Camino C A 8 Andando)
(Camino C B 5 Andando)
(Camino C D 6 Andando)
(Camino C G 6 Andando)
(Camino C H 6 Andando)

(Camino D C 6 Andando)
(Camino D H 14 Ambos)

(Camino E A 10 Ambos)
(Camino E I 20 Andando)
(Camino E J 9 Ambos)

(Camino F B 6 Andando)
(Camino F K 10 Andando)
(Camino F L 6 Andando)

(Camino G C 6 Andando)
(Camino G L 9 Andando)
(Camino G H 8 Andando)
(Camino G M 12 Andando)

(Camino H C 6 Andando)
(Camino H D 14 Ambos)
(Camino H G 8 Andando)
(Camino H I 12 Ambos)

(Camino I H 12 Ambos)
(Camino I E 20 Andando)
(Camino I O 2 Andando)

(Camino J E 9 Ambos)
(Camino J O 7 Ambos)

(Camino K F 10 Andando)
(Camino K L 2 Ambos)

(Camino L K 2 Ambos)
(Camino L F 6 Andando)
(Camino L G 9 Andando)
(Camino L M 7 Ambos)
(Camino L P 6 Ambos)

(Camino M L 7 Ambos)
(Camino M G 12 Andando)
(Camino M Q 2 Andando)

(Camino N Q 6 Andando)
(Camino N O 8 Ambos)

(Camino O I 2 Andando)
(Camino O J 7 Ambos)
(Camino O N 8 Ambos)

(Camino P L 6 Ambos)
(Camino P R 4 Ambos)
(Camino P Q 2 Andando)

(Camino Q P 2 Andando)
(Camino Q M 2 Andando)
(Camino Q R 3 Andando)
(Camino Q N 6 Andando)

(Camino R P 4 Ambos)
(Camino R Q 3 Andando)

;(transporte A B A pie coste 0 numOps 0 numPasos 0 PATH)
;;(transporte posInicial posFinal posActual pie/bici coste 0 numOps 0 numPasos 0 PATH )

)
;------------------------------------------------------------------------------------
;---------------------- VARIABLES GLOBALES-------------------------------------------
;------------------------------------------------------------------------------------
(defglobal ?*bases* = (create$ A B H J K M N R))
(defglobal ?*prof* = 0)
(defglobal ?*barrios* = (create$ A 1 B 2 C 2 D 2 E 2 J 2 F 3 G 3 H 3 I 3 O 3 K 4 L 4 M 4 N 4 P 5 Q 5 R 6))
(defglobal ?*minCam* = (create$ A 8 B 5 C 5 D 6 E 9 J 7 F 6 G 6 H 6 I 2 O 2 K 2 L 2 M 2 N 6 P 2 Q 2 R 3))
(defglobal ?*f* = 0)
;------------------------------------------------------------------------------------
;-------------------- FUNCIÓN HEURÍSTICA h(n) ---------------------------------------
;-------------------- h(n) = DistBarrios(n)*min(Cam(n))*Sit(n)----------------------- 
;------------------------------------------------------------------------------------
(deffunction heuristica (?posicion_Actual ?posicionFinal ?pieOBici)
 

	(bind ?i (member$ ?posicion_Actual ?*barrios*))
	(bind ?barrio_pos_act (nth$ (+ ?i 1) ?*barrios*))
	
	(bind ?i2 (member$ ?posicionFinal ?*barrios*))
	(bind ?barrio_pos_final (nth$ (+ ?i2 1) ?*barrios*))
	
	(bind ?coste_cambio_barrio (abs (- ?barrio_pos_final ?barrio_pos_act)))
	
	(bind ?i2 (member$ ?posicion_Actual ?*minCam*))
	(bind ?CaminoMinimo (nth$ (+ ?i2 1) ?*minCam*))
	
	(if (eq ?pieOBici  pie) then  (bind ?sit 1))
	(if (or (eq ?pieOBici  bici) (member$ ?posicion_Actual ?*bases*)) then  (bind ?sit 0.5))
	
	(bind ?res (* ?CaminoMinimo ?sit))
	(bind ?res (* ?res ?coste_cambio_barrio))
	(printout t "sit = " ?sit crlf)
	(printout t "Camino minimo desde " ?posicion_Actual " (andando)  " ?CaminoMinimo crlf)
	(printout t "Coste desde el barrio de " ?posicion_Actual " al barrio de " ?posicionFinal " es: " ?coste_cambio_barrio crlf)
	(integer ?res)

)
;------------------------------------------------------------------------------------
;---------------------- FUNCION CONTROL f(n)-----------------------------------------
;----------------------- f(n) = g(n) + h(n)------------------------------------------
;----------------------------- g(n) = coste -----------------------------------------
;------------------------------------------------------------------------------------
(deffunction control (?posicionSiguiente ?posicionFinal ?pieOBici ?coste_mas_coste_movimiento )
(bind ?*f* (heuristica ?posicionSiguiente ?posicionFinal ?pieOBici ))
(bind ?*f* (+ ?*f* ?coste_mas_coste_movimiento))
)
;------------------------------------------------------------------------------------
;---------------------- IR A PIE ----------------------------------------------------
;------------------------------------------------------------------------------------
(defrule IraPie
(declare (salience (- 0 ?*f*)))
(transporte ?posIni ?posFinal ?posAct pie coste ?coste numOps ?numOps numPasos ?numPasos PATH $?camino)
(Camino ?posAct ?y ?cost $?cualquiera)
(test (control ?y ?posFinal pie (+ ?coste ?cost)))
;(test (control ?y ?posFinal pie ?coste))
=>
(assert (transporte ?posIni ?posFinal ?y pie coste (+ ?coste ?cost) numOps (+ ?numOps 1) numPasos (+ ?numPasos 1) PATH $?camino ?y))
(printout t "ESTOY EN " ?posAct " y VOY ANDANDO a " ?y crlf)
)
;------------------------------------------------------------------------------------
;----------------------IR EN BICI ---------------------------------------------------
;------------------------------------------------------------------------------------
(defrule IrEnBici
(declare (salience (- 0 ?*f*)))
(transporte ?posIni ?posFinal ?posAct bici coste ?coste numOps ?numOps numPasos ?numPasos PATH $?camino)
(Camino ?posAct ?y ?cost Ambos)
(test (control ?y ?posFinal bici (+ ?coste ?cost)))
;(test (control ?y ?posFinal bici ?coste))
=>
(assert (transporte ?posIni ?posFinal ?y bici coste (+ ?coste (/ ?cost 2)) numOps (+ ?numOps 1) numPasos (+ ?numPasos 1) PATH $?camino ?y))
(printout t "ESTOY EN " ?posAct " y VOY EN BICI a " ?y crlf)
)
;------------------------------------------------------------------------------------
;----------------------COGER BICI ---------------------------------------------------
;------------------------------------------------------------------------------------
(defrule cogerBici
(declare (salience (- 0 ?*f*)))
(transporte ?posIni ?posFinal ?posAct pie coste ?coste numOps ?numOps $?resto)
(test (member$ ?posAct ?*bases*))
(test (control ?posAct ?posFinal bici (+ ?coste 1)))
;(test (control ?posAct ?posAct bici ?coste))
=>
(assert (transporte ?posIni ?posFinal ?posAct bici coste (+ ?coste 1) numOps (+ ?numOps 1) $?resto))
(printout t "COJO BICI EN " ?posAct crlf)
)
;------------------------------------------------------------------------------------
;----------------------DEJAR EN BICI-------------------------------------------------
;------------------------------------------------------------------------------------
(defrule dejarBici
(declare (salience (- 0 ?*f*)))
(transporte ?posIni ?posFinal ?posAct bici coste ?coste  numOps ?numOps $?resto)
(test (member$ ?posAct ?*bases*))
(test (control ?posAct ?posFinal pie (+ ?coste 1)))
;(test (control ?posAct ?posAct pie ?coste))
=>
(assert (transporte ?posIni ?posFinal ?posAct pie coste (+ ?coste 1) numOps (+ ?numOps 1) $?resto))
(printout t "DEJO BICI EN " ?posAct crlf)
)
;------------------------------------------------------------------------------------
;----------------------PARADA EXITO--------------------------------------------------
;------------------------------------------------------------------------------------
(defrule parada
(declare (salience 100))
(transporte ?posIni ?posFinal ?posFinal pie coste ?coste numOps ?numOps numPasos ?numPasos PATH $?camino)
=>
(printout t "ESTOY EN " ?posFinal " PARADA FINAL" crlf )
(printout t "Resultado Camino :" $?camino crlf)
(printout t "Coste Total :" ?coste crlf)
(printout t "Número de operaciones :" ?numOps crlf)
(halt)
)
;------------------------------------------------------------------------------------
;----------------------FUNCION INICIO------------------------------------------------
;------------------------------------------------------------------------------------
(deffunction inicio ()
    (reset)
	(printout t "Profundidad Maxima:= " )
	(bind ?*prof* (read))
	(printout t "Tipo de Busqueda " crlf "    1.- Anchura" crlf "    2.- Profundidad" crlf )
	(bind ?r (read))
	(if (= ?r 1)
	       then   (set-strategy breadth)
	       else   (set-strategy depth))
        (printout t " Ejecuta run para poner en marcha el programa " crlf)
	
	(assert (transporte A O A pie coste 0 numOps 0 numPasos 0 PATH A))
	
	

)
