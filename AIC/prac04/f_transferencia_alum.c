/**************************************************************************
 * 
 * Departamento de Informática de Sistema y Computadores (DISCA)
 * Universidad Politécnica de Valencia.                         
 * 
 * Author: Sergio Sáez (ssaez@disca.upv.es)
 * 
 * File: f_transferencia.c
 *  
 * Description: 
 *      Contiene la fase de transferencia por el bus común de datos para el
 *      algoritmo de Tomasulo con especulación.
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 *************************************************************************/

#define f_transferencia_alum_C

/***** Includes ***********************************************/

#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>

#include "main.h"
#include "instrucciones.h"
#include "prediccion.h"
#include "presentacion.h"
#include "algoritmo.h"
#include "tipos.h"

/***************************************************************
 *
 * Func: fase_WB
 *
 **************************************************************/

void fase_WB_alum() {
    /*************************************/
    /*  Variables locales                */
    /*************************************/

    marca_t i, s;

    ciclo_t orden;

    /*************************************/
    /*  Cuerpo función                   */
    /*************************************/

    /*** VISUALIZACIÓN ****/
    for (i = 0; i < TAM_ESTACIONES; i++) {
        if (RS[i].ocupado && RS[i].estado == FINALIZADA) {
            muestra_fase("-", RS[i].orden);
        } /* endif */
    } /* endif */
    /**********************/

    /*** Busca RS con resultados disponibles */

    orden = MAX_ORDEN;
    s = 0;

    for (i = 0; i < TAM_ESTACIONES; i++) {
        if (RS[i].ocupado && RS[i].estado == FINALIZADA && RS[i].orden < orden) {
            s = i;
            orden = RS[i].orden;
        } /* endif */
    } /* endif */

    if (orden >= MAX_ORDEN) return; /* No hay ninguna RS con resultados disponibles */

    /*** Volcado de resultados */

	/* INSERTAR CÓDIGO */
    BUS.valor = RS[s].resultado;
    BUS.codigo = RS[s].rob;

    /*** Libera la RS */
    RS[s].ocupado= NO;
	/* INSERTAR CÓDIGO */


    /*** VISUALIZACIÓN ****/
    RS[s].estado = PENDIENTE;
    BUS.excepcion = RS[s].excepcion;
    if (BUS.excepcion == EXC_NONE) {
      muestra_fase("WB", RS[s].orden);
    } else {
      muestra_fase("<font color=\"red\">WB</font>", RS[s].orden);
    }
    /**********************/
    
    /*** Lectura de resultados */

    /* Reorder buffer */
    RB[BUS.codigo].valor = BUS.valor; // Copia al RB
    RB[BUS.codigo].estado = WB; // lista para Commit
	/* INSERTAR CÓDIGO */


    if (BUS.excepcion != EXC_NONE) return; /* Si hay una excepción nadie utiliza el dato */
    
    /* Estaciones de reserva */

    for (s = INICIO_RS_ENTEROS; s <= FIN_RS_ENTEROS; s++) {
                // Operando 1
        if(RS[s].Qj==BUS.codigo){
            RS[s].Vj = BUS.valor; // lee dato del bus
            RS[s].Qj= MARCA_NULA; // borra marca
        }
        // Operando 2
        if(RS[s].Qk==BUS.codigo){
            RS[s].Vk = BUS.valor; // lee dato del bus
            RS[s].Qk = MARCA_NULA; // borra marca
        }
	/* INSERTAR CÓDIGO */

    } /* endfor */

    for (s = INICIO_RS_SUMA_RESTA;
            s <= FIN_RS_SUMA_RESTA; s++) {
                // Operando 1
            if(RS[s].Qj==BUS.codigo){
                RS[s].Vj = BUS.valor; // lee dato del bus
                RS[s].Qj = MARCA_NULA; // borra marca
            }
            // Operando 2
            if(RS[s].Qk==BUS.codigo){
                RS[s].Vk = BUS.valor; // lee dato del bus
                RS[s].Qk = MARCA_NULA; // borra marca
            }

	/* INSERTAR CÓDIGO */

    } /* endfor */

    for (s = INICIO_RS_MULT_DIV; s <= FIN_RS_MULT_DIV; s++) {
                // Operando 1
        if(RS[s].Qj==BUS.codigo){
            RS[s].Vj = BUS.valor; // lee dato del bus
            RS[s].Qj = MARCA_NULA; // borra marca
        }
        // Operando 2
        if(RS[s].Qk==BUS.codigo){
            RS[s].Vk = BUS.valor; // lee dato del bus
            RS[s].Qk = MARCA_NULA; // borra marca
        }
	/* INSERTAR CÓDIGO */

    } /* endfor */

    for (s = INICIO_TAMPON_LECT; s <= FIN_TAMPON_LECT; s++) {
                // Operando 1
        if(TL[s].Qj == BUS.codigo){
            TL[s].Vj = BUS.valor; // lee dato del bus
            TL[s].Qj = MARCA_NULA; // borra marca
        }

	/* INSERTAR CÓDIGO */

    } /* endfor */

    for (s = INICIO_TAMPON_ESCR; s <= FIN_TAMPON_ESCR; s++) {

    /* INSERTAR CÓDIGO */
    if(TE[s].Qj==BUS.codigo){ 
    TE[s].Vj = BUS.valor; // lee dato del bus
    TE[s].Qj = MARCA_NULA;// borra marca
    }
    // Operando 2
    if(TE[s].Qk==BUS.codigo){ 
    TE[s].Vk = BUS.valor; // lee dato del bus
    TE[s].Qk = MARCA_NULA; // borra marca
    }

    } /* endfor */

} /* end fase_WB */
