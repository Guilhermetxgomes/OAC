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
   return 0;
}

// Retorna a subtração entre a e b
mfloat subsf3(mfloat a, mfloat b) {
  return 0;
}
