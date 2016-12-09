#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#ifdef CONIO
#include <conio.h>
#else
#define clrscr() printf ("\e[2J")
#define gotoxy(x,y) printf ("\e[%d;%dH", x, y)
#endif

#define ROW_SIZE 8
#define uchar unsigned char

struct board_struct {
	uchar *board;	/* current board */
	uchar *pos;      /* current position */
	int dir;		/* current movable directions */
	int stp;		/* current stack pointer */
	uchar **stpos;   /* pointer to stack positions */
	int *sdir;		/* pointer to stack directions */
	int pcs;		/* starting no. of pieces */
};
uchar *board = "\
-------\n\
  OOO  \n\
  OOO  \n\
OOOOOOO\n\
OOO*OOO\n\
OOOOOOO\n\
  OOO  \n\
  OOO  \n\
-------\n";
void pr_board (struct board_struct *a)
{
	int stp = 0;

	gotoxy (1, 1);
	printf ("%s", a->board);
	while (stp < a->stp) {
		printf ("%2.2d%x ", a->stpos[stp] - a->board, a->sdir[stp]);
		stp++;
	}
}

int find_move(struct board_struct *a, int mod)
{
	uchar *ob = mod ? a->pos : a->board;
	int d;

	while ((ob = strchr (++ob, 'O')) != NULL) {
				d = (((*(ob - ROW_SIZE) == 'O') &&
			(*(ob - (2 * ROW_SIZE)) == '*')) ? 1 : 0) +
			(((*(ob + 1) == 'O') &&
			(*(ob + 2) == '*')) ? 2 : 0) +
			(((*(ob + ROW_SIZE) == 'O') &&
			(*(ob + (2 * ROW_SIZE)) == '*')) ? 4 : 0) +
			(((*(ob - 1) == 'O') &&
			(*(ob - 2) == '*')) ? 8 : 0);
		if (d) {
			a->pos = ob;
			a->dir = d;
			return (1);
		}
	}
	return (0);
}

int first_dir (int a)
{
	if (a & 1) return (1);
	if (a & 2) return (2);
	if (a & 4) return (4);
	if (a & 8) return (8);
}

void do_move (struct board_struct *a)
{
	uchar *po;
	int di, stp;

		*(po = a->stpos[stp = a->stp++] = a->pos) = '*';
	di = first_dir (a->sdir[stp] = a->dir);
		switch (di) {
	case 1: *(po - ROW_SIZE) = '*';
		*(po - (2 * ROW_SIZE)) = 'O';
		break;
	case 2: *(po + 1) = '*';
		*(po + 2) = 'O';
		break;
	case 4: *(po + ROW_SIZE) = '*';
		*(po + (2 * ROW_SIZE)) = 'O';
		break;
	case 8: *(po - 1) = '*';
		*(po - 2) = 'O';
		break;
	}
}
int re_move (struct board_struct *a)
{
	uchar *po;
	int d= 0, di, stp;

	while (!d) {
		if (a->stp <= 0) return (0);
				*(po = a->stpos[stp = --a->stp]) = 'O';
		di = first_dir (d = a->sdir[stp]);
				d ^= di;
		
		switch (di) {
		case 1: *(po - ROW_SIZE) = 'O';
			*(po - (2 * ROW_SIZE)) = '*';
			break;
		case 2: *(po + 1) = 'O';
			*(po + 2) = '*';
			break;
		case 4: *(po + ROW_SIZE) = 'O';
			*(po + (2 * ROW_SIZE)) = '*';
			break;
		case 8: *(po - 1) = 'O';
			*(po - 2) = '*';
			break;
		}
				if (!d) {
			a->pos = po;
			if (find_move (a, 1)) return (1);
		}
	}
	a->pos = po;
	a->dir = d;
	return (1);
}

struct board_struct *init_board (uchar *b)
{
	struct board_struct *a;
	uchar *ob;

	a = malloc (sizeof (struct board_struct));
	a->board = a->pos = ob = strdup (b);
	a->pcs = a->dir = a->stp = 0;
	while ((ob = strchr (++ob, 'O')) != NULL)
		a->pcs++;
	a->stpos = malloc (a->pcs * sizeof (uchar *));
	a->sdir = malloc (a->pcs * sizeof (int));
	return (a);
}

void free_board (struct board_struct *a)
{
	free (a->board);
	free (a->stpos);
	free (a->sdir);
	free (a);
}


void re_play (struct board_struct *a)
{
	int stp = 0;
	struct board_struct *aa;

	aa = init_board (board);
	pr_board (a);
	pr_board (aa); getc (stdin);
	while (stp < a->stp) {
		aa->pos = aa->board + (a->stpos[stp] - a->board);
		aa->dir = a->sdir[stp];
		do_move (aa);
		pr_board (aa); getc (stdin);
		stp++;
	}
	free_board (aa);
}

void main ()
{
	struct board_struct *a;
	int n = 0;

	a = init_board (board);
	clrscr();
	pr_board (a);
	while (1) {
		if (!find_move (a, 0)) {
			if (n++ > 30000) {
				n = 0;
				pr_board (a);
			}
			if (a->stp >= (a->pcs - 1))
				re_play (a);
			if (!re_move (a))
				break;
		}
		do_move (a);
	}
	pr_board (a);
	free_board (a);
}

