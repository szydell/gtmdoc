/*
 * collation.c	Alternative collation sequence
 *
 */
#include <stdio.h>
#include "gtm_descript.h"

#define COLLATION_TABLE_SIZE		256
#define MYAPPS_SUBSC2LONG		12345678
#define SUCCESS     0
#define FAILURE     1
#define VERSION	    0

static unsigned char xform_table[COLLATION_TABLE_SIZE] =
	{
	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
	16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31,
	32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47,
	48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63,
	64, 65, 67, 69, 71, 73, 75, 77, 79, 81, 83, 85, 87, 89, 91, 93,
	95, 97, 99,101,103,105,107,109,111,113,115,117,118,119,120,121,
	122, 66, 68, 70, 72, 74, 76, 78, 80, 82, 84, 86, 88, 90, 92, 94,
	96, 98,100,102,104,106,108,110,112,114,116,123,124,125,126,127,
	128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,
	144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,
	160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,
	176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,
	192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,
	208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,
	224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,
	240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255
	};

static unsigned char inverse_table[COLLATION_TABLE_SIZE] =
	{
	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
	16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31,
	32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47,
	48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63,
	64, 65, 97, 66, 98, 67, 99, 68,100, 69,101, 70,102, 71,103, 72,
	104, 73,105, 74,106, 75,107, 76,108, 77,109, 78,110, 79,111, 80,
	112, 81,113, 82,114, 83,115, 84,116, 85,117, 86,118, 87,119, 88,
	120, 89,121, 90,122, 91, 92, 93, 94, 95, 96,123,124,125,126,127,
	128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,
	144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,
	160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,
	176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,
	192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,
	208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,
	224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,
	240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255
	};


long gtm_ac_xform ( gtm_descriptor *src, int level, gtm_descriptor *dst, int *dstlen)
{
	int n;
	unsigned char  *cp, *cpout;
#ifdef DEBUG 
	char 	input[COLLATION_TABLE_SIZE], output[COLLATION_TABLE_SIZE];
#endif
	n = src->len;
	if ( n > dst->len)
		return MYAPPS_SUBSC2LONG;

	cp  = (unsigned char *)src->val;
#ifdef DEBUG
	memcpy(input, cp, src->len);
	input[src->len] = '\0';
#endif
	cpout = (unsigned char *)dst->val;

	while ( n-- > 0 )
	   *cpout++ = xform_table[*cp++];

        *cpout = '\0';
	
	*dstlen = src->len;
#ifdef DEBUG
	memcpy(output, dst->val, dst->len);
	output[dst->len] = '\0';

	fprintf(stderr, "\nInput = \n");
	for (n = 0; n < *dstlen; n++ ) fprintf(stderr," %d ",(int )input[n]);
	fprintf(stderr, "\nOutput = \n");
	for (n = 0; n < *dstlen; n++ ) fprintf(stderr," %d ",(int )output[n]);
#endif

	return SUCCESS;
}

long gtm_ac_xback ( gtm_descriptor *src, int level, gtm_descriptor *dst, int *dstlen)
{
	int	n;
	unsigned char  *cp, *cpout;
#ifdef DEBUG 
	char 	input[256], output[256];
#endif

	n = src->len;
	if ( n > dst->len)
		return MYAPPS_SUBSC2LONG;

	cp  = (unsigned char *)src->val;
	cpout = (unsigned char *)dst->val;

	while ( n-- > 0 )
	   *cpout++ = inverse_table[*cp++];

        *cpout = '\0';
	
	*dstlen = src->len;
#ifdef DEBUG
	memcpy(input, src->val, src->len);
	input[src->len] = '\0';
	memcpy(output, dst->val, dst->len);
	output[dst->len] = '\0';
	fprintf(stderr, "Input = %s, Output = %s\n",input, output);
#endif

	return SUCCESS;
}

int gtm_ac_version ()
{
	return VERSION;
}

int gtm_ac_verify (unsigned char type, unsigned char ver)
{
    	return !(ver == VERSION);
}
