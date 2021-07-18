#!/usr/bin/env python3
# -*- coding: utf-8 -*-


# --- IMPLEMENTATION GOES HERE -----------------------------------------------
#  Student helpers (functions, constants, etc.) can be defined here, if needed

# Funcion para convertir un texto ascii en binario
def conv_to_bin(text):
    binary = []
    for char in text:
        # Se verifica si el texto pasado contiene espacios
        if char == ' ':
            binary.append('00100000')  # codificacion binaria del espacio en blanco en ASCII
        else:
            binary.append(bin(ord(char)))  # pasamos cada caracter a binario
        # El contenido del vector, se pasa a una string.
        # Al pasarse a binario el formato incluye una b, por lo que hay que eliminarla
    b_str = ''.join(str(b_str) for b_str in binary)
    bin_text = (b_str.replace('b', ''))
    return bin_text

# Clase que se va a usar para pasar de binario a ascii
# le pasamos una cadena que contiene el binario en bloques separados de 8 bits
# cada bloque corresponde a una de las letras
class conversor():
    def conv_to_ascii(self, text):
        x = text.split()
        result = ''
        for i in range(len(x)):
            result += chr(self.pass_bin_to_ascii(int(x[i])))
        return result

    def pass_bin_to_ascii(self, text):
        dec = 0
        i = 0
        for j in self.invertir(str(text)):
            if (int(j) == 1):
                dec = dec + 2 ** i
            i = i + 1
        return dec

    def invertir(self, var):
        return var[::-1]


def uoc_lfsr(polynomial, initial_state, num_bits):
    """
    EXERCISE 1.1: LFSR implementation
    :polinomial: LFSR connection polynomial
    :initial_state: LFSR initial state
    :num_bits: Number of output bits
    :return: string of 0s and 1s with the output sequence
    """

    output = ""

    # --- IMPLEMENTATION GOES HERE ---
    # Invierto el orden del polinonio para recorrerlo en el mismo orden que
    # el vector del estado inicial
    # dado que el primer valor corresponde a 1 en base a la formula del polinomio, lo elimino
    new_pol = []
    for item in reversed(polynomial):
        new_pol.append(item)
    new_pol.pop()
    # las posiciones de new_pol que tengan valor 1 son las posiciones que estaran "conectadas" y
    # sobre las que habra que hacer un xor y su resultado habra que añadir como nuevo estado al
    # final de la lista initial_state
    for i in range(0, num_bits):
        temporal = []
        for i in range(0, len(initial_state)):
            if new_pol[i] == 1:
                temporal.append(initial_state[i])
        XOR = 0
        for i in range(0, len(temporal)):
            if temporal[i] == XOR:
                XOR = 0
            else:
                XOR = 1
        initial_state.append(XOR)
        output += str(initial_state[0])
        del (initial_state[0])

    # --------------------------------

    return output



def uoc_geffe_generator(parameters_pol_0, parameters_pol_1, 
                        parameters_pol_2, num_bits):
    """
    EXERCISE 1.2: Geffe generator implementation
    :parameters_pol_X: A tupple with the LFSR connection polynomial and the
                       LFSR initial state)
    :num_bits: Number of output bits
    :return: string of 0s and 1s with the result
    """

    output = ""

    # --- IMPLEMENTATION GOES HERE ---

    def func_lfsr(polynomial, initial_state, num_bits):
        new_pol = []
        salida = []
        for item in reversed(polynomial):
            new_pol.append(item)
        new_pol.pop()
        for i in range(0, num_bits):
            temporal = []
            for i in range(0, len(initial_state)):
                if new_pol[i] == 1:
                    temporal.append(initial_state[i])
            XOR = 0
            for i in range(0, len(temporal)):
                if temporal[i] == XOR:
                    XOR = 0
                else:
                    XOR = 1
            initial_state.append(XOR)
            salida.append(initial_state[0])
            del (initial_state[0])
        return salida

    lfsr_0 = func_lfsr(parameters_pol_0[0], parameters_pol_0[1], num_bits)
    lfsr_1 = func_lfsr(parameters_pol_1[0], parameters_pol_1[1], num_bits)
    lfsr_2 = func_lfsr(parameters_pol_2[0], parameters_pol_2[1], num_bits)


    for i in (range(0, num_bits)):
        if lfsr_0[i] == 0:
            output += str(lfsr_1[i])
        else:
            output += str(lfsr_2[i])

    # --------------------------------

    return output



def uoc_geffe_cipher(parameters_pol_0, parameters_pol_1, 
                     parameters_pol_2, message, mode):
    """
    EXERCISE 1.3: Geffe cipher implementation
    :parameters_pol_X: A tupple with the LFSR connection polynomial and the
                       LFSR initial state)
    :message: string of 0s and 1s with the message todecrypt or text to
              encrypt in ASCII
    :mode: 'e' for encryption, or 'd' for decryption
    :return: encrypted or decrypted message
    """

    output = ""

    # --- IMPLEMENTATION GOES HERE ---
    if mode == "e":
        # convertimos el message a binario y miramos su longitud
        # generamos una clave de cifrado de la misma longitud que el binario del mensaje
        # hacemos xor bit a bit entre el binario del mensaje y la clave de cifrado
        text_bin = conv_to_bin(message)
        num_bits = len(text_bin)
        cif_key = uoc_geffe_generator((parameters_pol_0[0],parameters_pol_0[1]), (parameters_pol_1[0],parameters_pol_1[1]), (parameters_pol_2[0],parameters_pol_2[1]), num_bits)

        for i in range(0, len(text_bin)):
            output += str(int(text_bin[i]) ^ int(cif_key[i]))

    else:
        # generamos una clave de descifrado de la misma longitud que el mensaje en binario pasado para descifrar
        # hacemos xor bit a bit entre el mensaje y la clave de descifrado
        call = conversor();
        temporal = ""
        flag = 0
        temp = ""
        num_bits = len(message)
        descif_key = uoc_geffe_generator((parameters_pol_0[0],parameters_pol_0[1]), (parameters_pol_1[0],parameters_pol_1[1]), (parameters_pol_2[0],parameters_pol_2[1]), num_bits)

        for i in range(0, len(descif_key)):
            temporal += str(int(message[i]) ^ int(descif_key[i]))

        # La nueva cadena de binarios obtenida del xor la dividimos en bloques de 8 bits separados por un espacio, lo que corresponde a cada letra
        for i in range(0, len(temporal)):
            if flag < 8:
                temp += str(temporal[i])
                flag += 1
            else:
                temp += " " + str(temporal[i])
                flag = 1

        output = call.conv_to_ascii(temp)

    # --------------------------------

    return output



def uoc_trivium_shift_register_output(state, feedforward_bit, and_inputs):
    """ 
    EXERCISE 2.1: Computes the output bit of a single trivium shift register
    :state: list with the binary representation of the register
    :feedforward_bit: integer, position of the feedforward bit
    :and_inputs: list of two integers, positions of the and bits
    :return: the output bit and the and bit
    """ 
   
    output_bit = -1
    
    # --- IMPLEMENTATION GOES HERE ---
    # hacemos -1 a todas las posiciones por que el vector empieza en 0
    # Hacer xor de la posicion que indica feedforward_bit y la ultima del vector
    output_bit = state[feedforward_bit-1]^state[-1]

    # Hacemos el and de las posiciones que nos indica and_inputs
    and_result = state[and_inputs[0]-1] and state[and_inputs[1]-1]

    # --------------------------------

    return output_bit, and_result


def uoc_trivium_shift_register_update(state, new_bit, and_prev_result, 
                                      feedback_bit):
    """ 
    EXERCISE 2.2: Update the internal state of a single trivium shift register
    :state: list with the binary representation of the register
    :new_bit: value of the bit from the other register
    :and_prev_result: value of the bit from the AND of the previous register 
    :feedback_bit: position of the feedback bit
    :return: binary representation of the new state of the register
    """

    new_state = []
    valor = -1
    
    # --- IMPLEMENTATION GOES HERE ---
    # hacemos xor de los valores de salida del otro registro, and del registro previo
    # y el feedback bit
    # este valor sera el que entre a la primera posicion del nuevo estado y sale el
    # ultimo
    valor = new_bit ^ and_prev_result ^ state[feedback_bit - 1]
    new_state.append(valor)
    state.pop()
    for i in range(0, len(state)):
        new_state.append(state[i])
    

    # --------------------------------
    
    return new_state



def uoc_trivium_generator(iv, key, num_bits):
    """
    EXERCISE 2.3: Computes the output of the trivium generator
    :iv: binary representation of the initial vector
    :key: binary representation of the key
    :num_bits: number of output bits
    :return: binary representation of the generated stream
    """

    output = []
    
    # --- IMPLEMENTATION GOES HERE ---
    vec_A = []
    vec_B = []
    vec_C = []

    # Creacion del vector A a partir de la Key
    for i in range(0, 93):
        if i < 80:
            vec_A.append(key[i])
        else:
            vec_A.append(0)

    # Creacion del vector B a partir del vector de inicializacion iv
    for i in range(0, 84):
        if i < 80:
            vec_B.append(iv[i])
        else:
            vec_B.append(0)

    # Creacion del vector C
    for i in range(0, 111):
        if i < 108:
            vec_C.append(0)
        else:
            vec_C.append(1)

    for i in range(0, 1152 + num_bits):
        # Calculo de las salidas de cada vector. Al empezar en 0, se resta -1 a las posiciones en los calculos
        t_a = vec_A[92] ^ vec_A[65]
        t_b = vec_B[83] ^ vec_B[68]
        t_c = vec_C[110] ^ vec_C[65]
        # A partir de la salida de cada vector, tenemos la salida del Trivium
        z = t_a ^ t_b ^ t_c

        # Calculo de los valores de retroalimentacion para cada vector
        a_new = t_c ^ (vec_C[108] and vec_C[109]) ^ vec_A[68]
        b_new = t_a ^ (vec_A[90] and vec_A[91]) ^ vec_B[77]
        c_new = t_b ^ (vec_B[81] and vec_B[82]) ^ vec_C[86]

        # Paa cada vector añadimos el valor de la celda de retroalimentacion y eliminamos el que sale en la
        # ultima posicion
        vec_A.insert(0, a_new)
        vec_A.pop()
        vec_B.insert(0, b_new)
        vec_B.pop()
        vec_C.insert(0, c_new)
        vec_C.pop()

        output.append(z)

        # Podriamos hacer if i >= 1152 para empezar a escribir en output
        # despues de 1152 iteraciones y retornar directamente el output

    # --------------------------------

    return output[1152:]




def uoc_trivium_cipher(message, key, iv, mode):
    """
    EXERCISE 1.3: Trivium cipher implementation
    :message: string of 0s and 1s with the message todecrypt or text to
              encrypt in ASCII
    :key: string of 0s and 1s with the key
    :mode: 'e' for encryption, or 'd' for decryption
    :return: encrypted or decrypted message
    """

    output = ""

    # --- IMPLEMENTATION GOES HERE ---
    if mode == "e":
        # convertimos el message a binario y miramos su longitud
        # generamos una clave de cifrado de la misma longitud que el binario del mensaje
        # hacemos xor bit a bit entre el binario del mensaje y la clave de cifrado
        text_bin = conv_to_bin(message)
        num_bits = len(text_bin)
        cif_key = uoc_trivium_generator(iv, key, num_bits)

        for i in range(0, len(text_bin)):
            output += str(int(text_bin[i]) ^ int(cif_key[i]))

    else:
        # generamos una clave de descifrado de la misma longitud que el mensaje en binario pasado para descifrar
        # hacemos xor bit a bit entre el mensaje y la clave de descifrado
        call = conversor();
        temporal = ""
        flag = 0
        temp = ""
        num_bits = len(message)
        descif_key = uoc_trivium_generator(iv, key, num_bits)

        for i in range(0, len(descif_key)):
            temporal += str(int(message[i]) ^ int(descif_key[i]))

        # La nueva cadena de binarios obtenida del xor la dividimos en bloques de 8 bits separados por un espacio, lo que corresponde a cada letra
        for i in range(0, len(temporal)):
            if flag < 8:
                temp += str(temporal[i])
                flag += 1
            else:
                temp += " " + str(temporal[i])
                flag = 1

        output = call.conv_to_ascii(temp)
    

    # --------------------------------

    return output








