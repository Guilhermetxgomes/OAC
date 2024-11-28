#include <inttypes.h>
#include "float_lib.h"


typedef int32_t mint;
typedef uint32_t mfloat;

// Constantes IEEE 754
#define EXP_MASK 0x7F800000
#define FRAC_MASK 0x007FFFFF
#define SIGN_MASK 0x80000000
#define EXP_BIAS 127

// Converte um inteiro para ponto flutuante
mfloat floatsisf(mint i) {
  if (i == 0) {
      return 0;
  }

  int32_t sinal = (i < 0) ? 1 : 0;
  if (sinal) i = -i;

  int32_t expoente = 31;
  while ((i & (1 << expoente)) == 0) {
      expoente--;
  }

  expoente = expoente + EXP_BIAS;


  uint32_t mantissa = 0;


  for (int contadorShift = 0; contadorShift < expoente - EXP_BIAS; contadorShift++) {
      mantissa |= (i & 1) << 31;
      mantissa >>= 1;
      i >>= 1;
  }
    mantissa >>= 8;


    mfloat resultado = (sinal << 31) | (expoente << 23) | mantissa;

    return resultado;
}

// Converte um ponto flutuante para inteiro
mint fixsfsi(mfloat a) {
  uint32_t sinal = (a & SIGN_MASK) >> 31;
  uint32_t expoente = ((a & EXP_MASK) >> 23);
  uint32_t mantissa = (a & FRAC_MASK);

  if (mantissa ==0 && expoente == 0) {
    return 0;
  }

  if (expoente != 0) mantissa |= (1 << 23);

  expoente -= EXP_BIAS;

  int32_t resultado;

  if(expoente >= 32){
    resultado = 0;
  } else if (expoente <= 23){
    resultado = mantissa >> (23 - expoente);
  } else {
    resultado = mantissa << expoente - 23;
  }

  if(sinal) resultado *= -1;

  return resultado;
}

// Retorna o negado de a
mfloat negsf2(mfloat a) {
  return a ^ SIGN_MASK;
}

// Retorna a soma entre a e b
mfloat addsf3(mfloat a, mfloat b) {
    uint32_t sinal_a = (a & SIGN_MASK) >> 31;
    uint32_t sinal_b = (b & SIGN_MASK) >> 31;
    int32_t expoente_real_a = ((a & EXP_MASK) >> 23) - EXP_BIAS;
    int32_t expoente_real_b = ((b & EXP_MASK) >> 23) - EXP_BIAS;
    uint32_t mantissa_a = (a & FRAC_MASK) | (expoente_real_a ? (1 << 23) : 0);
    uint32_t mantissa_b = (b & FRAC_MASK) | (expoente_real_b ? (1 << 23) : 0);

    if (expoente_real_a > expoente_real_b) {
        int32_t diff = expoente_real_a - expoente_real_b;
        if (diff > 31) { // Precisa checar pra nao deslocar demais e perder a mantissa
            mantissa_b = 0;
        } else {
            mantissa_b >>= diff;
        }
        expoente_real_b = expoente_real_a;
    } else if (expoente_real_b > expoente_real_a) {
        int32_t diff = expoente_real_b - expoente_real_a;
        if (diff > 31) {
            mantissa_a = 0;
        } else {
            mantissa_a >>= diff;
        }
        expoente_real_a = expoente_real_b;
    }

    int32_t resultado_expoente = expoente_real_a;
    uint32_t resultado_mantissa;
    uint32_t sinal_resultado = sinal_a;

    if (sinal_a == sinal_b) {
        resultado_mantissa = mantissa_a + mantissa_b;

        if (resultado_mantissa & (1 << 24)) {
            resultado_mantissa >>= 1;
            resultado_expoente += 1;
        }
    } else {
        if (mantissa_a >= mantissa_b) {
            resultado_mantissa = mantissa_a - mantissa_b;
            sinal_resultado = sinal_a;
        } else {
            resultado_mantissa = mantissa_b - mantissa_a;
            sinal_resultado = sinal_b;
        }
    }

    if (resultado_mantissa == 0) {
        return 0;
    }

    uint32_t expoente_final = resultado_expoente + EXP_BIAS;

    // SE O NUMERO NAO FOR DENORMALIZADO...
    if (expoente_final > 0) {
        resultado_mantissa &= FRAC_MASK;
    }

    mfloat resultado = (sinal_resultado << 31) | (expoente_final << 23) | (resultado_mantissa);

    return resultado;
}

// Retorna a subtração entre a e b
mfloat subsf3(mfloat a, mfloat b) {
  return addsf3(a, negsf2(b));
}
