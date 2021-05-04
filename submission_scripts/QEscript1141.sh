#!/bin/bash
###VERSAO 1.1.4.0 05/04/21
## plot pdosgeral ta incluindo nspin=2, adicionei um pdos specified que permite plotar
## os atomos separadamento e fazer somas especificas mais facil
### Plot 3d de polarizacao de spin incluido no PP. plotnum=6
### total potential in 3d incluido no pp plotnum=1
## include getGapSP.py
## include baderaverage_bonds.py
## plot_PDOS_geral.py -> plot_PDOS_geralSP.py, 
## plot_PDOS_specified.py can plot individual pdos files and their sums easier


###VERSAO 1.1.3.9 28/12
## atualizei os arquivos de plot pdos e plot bands para serem produzidos 

### VERSAO 1.1.3.8 22/12
## um problema com nscf e bands nao tava incluindo as bandas extras se nao estivesse 
## com o out.relax disponivel.

### VERSAO 1.1.3.7 07/12
## tinha pulado a versao 1.1.3.4

### VERSAO 1.1.3.6 30/11
## reinicializacao do relax do scf e nscf nao estavam iguais
## nscf nao estava pegando coords relaxadas

##### VERSAO 1.1.3.5 18/11
## nao estava rodando o PP no aws
##### VERSAO 1.1.3.4 02/11
## inclui flags para a AWS

##### VERSAO 1.1.3.3 11/08
## ajustei para plotar kresolved nas bandas
## nao precisa mais de degauss no DOS, ajustei o plotting e eliminei.

##### VERSAO 1.1.3.2 29/07
## ufpel e furg nao tinha pwtoolsdir
## ibrav=0 nao estava relaxando automatico desde as ultimas correcoes

##### VERSAO 1.1.3.1 26/06
## A variavel CONTROL nao estava incluida no caso kgrid para relax

##### VERSAO 1.1.3.0 25/05
## erro grave nao executava o PP

##### VERSAO 1.1.2.9 15/05
## erro do DOSplotted no PP corrigido
## shifts de kgrid no scf e nscf
# gridshift_scf=1
# gridshift_nscf=1

##### VERSAO 1.1.2.8 06/05
## correcao do diretorio do QE e pseudo para scratch no SDUMONT

###### VERSAO 1.1.2.7 25/04
# incluindo um rascunho a testar para SDUMONT
# rascunho melhorado e ibrav 11 incluido nos ibrav implementados

###### VERSAO 1.1.2.6 08/04
# chave bandshybrid incluida para fazer calculo scf com caminho de kpoints no formato de bandas
# isso e util para funcional hibrido em que nao podemos fazer nscf ou calculo de bandas no qe6.5<
# alem disso o script hybridbands.py sera gerado na pasta para calcular as bandas a partir do
# arquivo INPUT.xml gerado na pasta OUTPUT
# calcscf=1
# kptgrid=(6 6 4)  ## certifique-se da convergencia
# bandshybrid=1 ## usar BANDS kpoints no scf para funcional hibrido

###### VERSAO 1.1.2.5 11/03
## se relax caia nao gerava os .xsf que precisa para o scf
## inclui as linhas para gerar o scf

###### VERSAO 1.1.2.4 04/03 
## SYSTEM_RELAXED tinha um erro na hora de deletar os parametros de rede
## Correcoes no plotPDOS e sumPDOS para ignorar comentarios e funcionar quando nspin nao e declarado
## o pp do bnd nao estava sendo executado, estava rodando pp duas vezes.

###### VERSAO 1.1.2.3 25/02 
## SYSTEM_RELAXED tem que ser invocado somente quanto existir o arquivo out.$INPUT.relax
## caso contrario pegar o SYSTEM e CELL_AND_ATOMS que esta no inputQE.

###### VERSAO 1.1.2.2 14/02 - 17/02
## para evitar o problema de hanging que acontece no CESUP FERMI quando usa GPU.
## agora pega o JobID na hora de submeter o qsub e entao usa qdel para deletar o job caso
## a condicao JOB DONE seja encontrada na saida.
#
## PP bands estava rodando mesmo quando nao foi feito o calculo de bandas.Corrigido.
## inclui uns ifs no PP
#
## inclui o arquivo plotgeral-DOS.py na pasta PDOS, para customizar os plots.
#
## implementei o ibrav diferente de zero para relaxacao com a funcao SYSTEM_RELAXED.
#
## implementando as simulacoes de convergencia coalescidas no mesmo input, faz todos ecutwfc
## e depois todos os kgrid no mesmo input de submissao, economizando tempo de alocacao.
## para isso esta usando as funcoes CESUP_ADD e CESUP_SUBMIT_ADD, nao tem implementado fora do CESUP.
##
## usando o ibrav extraido direto da variavel SYSTEM, ja atribui ibrav0 1 ou 0 automaticamente. Nao precisa mais
## declarar.

###### VERSAO 1.1.2.1 31/01
## problema na analise de bader corrigido

##### VERSAO 1.1.2.0 30/01
## comando para fazer uma relaxacao com aplicacao de pressao em uma direcao especifica
## ativado com calcpress=1
##### calculo para pressao ##################################
# calcpress=1
#    restartfromcycle=0
#    gammapoint=0  ## relaxacao com ponto gamma.
#    kgridrelax=1    ## relaxacao com kgrid somente para casos de dificil convergencia.
#      kptgrid_relax=(5 5 3)
#  cyclespressure=20  ## how many cycles of relaxation
#  pressure_direction="z"    ## direction where pressure will be applied
#  relaxing_direction="xy"
#  pressure=150   ### its isostatic therefore will not be the same in the pressure direction
#  max_displacement=0.1 ## in angstrom
################################################################

##### VERSAO 1.1.1.9 27/01
## apos a relaxacao faz uma copia da saida com sufixo relaxed
## palavra chave para relaxar somente os ions, fixcell. 
 #   kgridrelax=1    ## relaxacao com kgrid somente para casos de dificil convergencia.
 #   kptgrid_relax=(5 5 2)
 #   fixcell=1 

##### VERSAO 1.1.1.8 25/01
## correcao do xsf e dist antes e pos relaxacao

##### VERSAO 1.1.1.7 24/01
### kgridrelax ao inves de kgrid222 para relaxacao, permite um kgrid customizado.
 #   kgridrelax=1    ## relaxacao com kgrid somente para casos de dificil convergencia.
 #   kptgrid_relax=(5 5 2)

##### VERSAO 1.1.1.6 24/01
## para obter o xsf automaticamente antes e apos a relaxacao.

##### VERSAO 1.1.1.5 17/01
### quando ibrav especificado e foi feita uma relaxacao de celula nao atualiza os parametros de rede.
### precisa previnir que siga o calculo scf nscf automaticamente

##### VERSAO 1.1.1.4 07/01
##### criei um fixrelax para um caso especifico
##### tem um problema na obtencao das coordenadas relaxadas que aconteceu no mos2_lateral_831, por algum motivo  
##### saiu do padrao e o script nao pode obter corretamente, seria bom implementar um comando que pegasse a partir
##### da linha ATOMIC_POSITIONS ou CELL_PARAMETERS ao inves do numero de linhas, isso evitaria o problema.

#### VERSAO 1.1.1.3 03/01 
## homo lumo so precisa do ponto gamma que e o primeiro ponto k em geral.
#### VERSAO 1.1.1.2 30/12
## outra correcao caso nspin=2, um correcao tinha desaparecido
#### VERSAO 1.1.1.1 25/12
## corrigido quando nao tem nspin no input
#### VERSAO 1.1.1.0 23/12
## Correcao para analise de bader, achava que ja tinha realizado se tivesse o arquivo cube, chegando pelo .dat agora.
#### VERSAO 1.1.0.9 23/12
## Arrumei algoritmos para o calculo de dft+U
#### VERSAO 1.1.0.8 22/12
## FermiLOCAL para usar versao local com dft+U nos elementos Cs Sb Cl Br I
#### VERSAO 1.1.0.7 17/12
## FermiGPU alterado para o caminho /opt/qe/bin

#### VERSAO 1.1.0.6 29/11
## sumpdos e plotpdos com nspin=2

#### VERSAO 1.1.0.5 27/11
## executaveis do fermi corrigidos novamente

#### VERSAO 1.1.0.4  20/11
### correcoes para plotar quando material nao tem gap
### nao estava imprimindo o Eg corretamente no grafico
### troquei o caminho de execucao no fermi
#### VERSAO 1.1.0.3  19/11 
#### correcoes para usar o python3 na ufpel

#### VERSAO 1.1.0.2  16/11 1:30
###  FEITO! adiciona memoria
###  FEITO! flags de paralelizacao
###  FEITO! - URGENTE:   se ibrav diferente de zero pegar apenas as coordenadas relaxadas e nao os parametros de rede.
###  FEITO! URGENTE:   implementar a configuracao para rodar no newton.
###  FEITO! URGENTE:   convergencia cutoff apenas com ponto gamma!
###  FEITO! kpoints com base na razao entre parametros de rede
###  FEITO! renomear arquivos do bader, 
###  FEITO!! script python para plotar o DOS e as bandas
###  FEITO! nscf - calcular o gap

###  implementar:
###  calculo de hubbard com analise de bader e PPpython apos cada estrutura?
###  usar ecutwfc convergido para calculo de kpoints
###  melhorar algoritmo que calcula o gap no plot
###  integrar com o cif2cell se nao ficar muito baguncado
###  gerar automaticamente o caminho para calculo de bandas
###  algo que permita saber ate onde calculou com sucesso
###  criar uma flag de execucao do tipo ./SCRIPTGERAL.sh clean
###  para limpar os arquivos de saida, outra flag para comprimir arquivos

### tempo inicial
touch TIME_SPENT
res1=$(date +%s.%N)

source ./inputQE.sh   ## pega as variaveis definidas no inputQE

PARALLELFLAGSini=$PARALLELFLAGS    
# copia parallelflags para recuperar depois de calculos com ponto gamma 

LC_NUMERIC=C  ## problema no seq, forca usar ponto como separador decimal


####### funcao calculo da estrutura pelo cif e tambem o caminho da rede reciproca ###
function ceil() {
  echo "define ceil (x) {if (x<0) {return x/1} \
        else {if (scale(x)==0) {return x} \
        else {return x/1 + 1 }}} ; ceil($1)" | bc
}

####### funcao calculo da estrutura pelo cif e tambem o caminho da rede reciproca ###
if [ "$unknown" = 1 ] ; then    ## naoo implementado.
cif2cell -p pwscf -f zno-wurzita.cif -o zno-wurtzita.in --pwscf-cartesian-latticevectors  --pwscf-pseudostring=.upf 
cat > seekpath-$INPUT.py << EOF
import seekpath
lattice = [ [ 2.807394551448014,  -1.620850000000000,   0.000000000000000 ],
 [ 0.000000000000000,   3.241700000000000,   0.000000000000000 ],
[  0.000000000000000,   0.000000000000000,   5.187600000000000]  ]

positions = [
[  0.333333333333333,   0.666666666666667,   0.000000000000000 ],
[ 0.666666666666667,   0.333333333333333,   0.500000000000000 ],
[ 0.333333333333333,   0.666666666666667,   0.381900000000000 ],
 [ 0.666666666666667,   0.333333333333333,   0.881900000000000 ]
]

numbers = [1, 1, 2, 2]
## precisa usar os parametros de rede do seekpath no final do mesmo jeito para as bandar terem validade.
structure = (lattice, positions, numbers)
#seekpath.get_path(structure, with_time_reversal, recipe, threshold, symprec, angle_tolerance)
print(seekpath.get_path(structure))
EOF

conda activate myenv
python seekpath-$INPUT.py

fi

######## FUNCAO PARA PEGAR AS COORDENADAS RELAXADAS APOS ReLAXACAO BEM SUCEDIDA #######

function SYSTEM_RELAXED () {
SYSTEM_RELAXED=$(echo "$SYSTEM" | sed "/A\s*=/d" )
SYSTEM_RELAXED=$(echo "$SYSTEM_RELAXED" | sed "/B\s*=/d" )
SYSTEM_RELAXED=$(echo "$SYSTEM_RELAXED" | sed "/C\s*=/d" )

## para ler os vetores de rede da estrutura relaxada.
IFS=" " read -r -a a_vct <<< "$(sed -n 3p $INPUT.relaxed.xsf )"
IFS=" " read -r -a b_vct <<< "$(sed -n 4p $INPUT.relaxed.xsf )"
IFS=" " read -r -a c_vct <<< "$(sed -n 5p $INPUT.relaxed.xsf )"

## codigo para pegar o numero do ibrav
ibrav=$(echo "$SYSTEM" | grep "ibrav" | awk -F'=' {'print $2'} | sed 's/[^0-9]*//g' )

if [[ "$ibrav" = "1" ]] ; then
SYSTEM_RELAXED=$(echo "$SYSTEM_RELAXED" | sed "3s/$/\n A = ${a_vct[0]} /" )

elif [[ "$ibrav" = "4" ]] ; then
SYSTEM_RELAXED=$(echo "$SYSTEM_RELAXED" | sed "3s/$/\n A = ${a_vct[0]} /" )
SYSTEM_RELAXED=$(echo "$SYSTEM_RELAXED" | sed "3s/$/\n C = ${c_vct[2]} /" )
	
elif [[ "$ibrav" = "6" ]] ; then
SYSTEM_RELAXED=$(echo "$SYSTEM_RELAXED" | sed "3s/$/\n A = ${a_vct[0]} /" )
SYSTEM_RELAXED=$(echo "$SYSTEM_RELAXED" | sed "3s/$/\n C = ${c_vct[2]} /" )
	
elif [[ "$ibrav" = "8" ]] ; then
SYSTEM_RELAXED=$(echo "$SYSTEM_RELAXED" | sed "3s/$/\n A = ${a_vct[0]} /" )
SYSTEM_RELAXED=$(echo "$SYSTEM_RELAXED" | sed "3s/$/\n B = ${b_vct[1]} /" )
SYSTEM_RELAXED=$(echo "$SYSTEM_RELAXED" | sed "3s/$/\n C = ${c_vct[2]} /" )


elif [[ "$ibrav" = "11" ]] ; then
SYSTEM_RELAXED=$(echo "$SYSTEM_RELAXED" | sed "3s/$/\n A = $( expr 2*${a_vct[0]} | bc ) /" )
SYSTEM_RELAXED=$(echo "$SYSTEM_RELAXED" | sed "3s/$/\n B = $( expr 2*${b_vct[1]} | bc ) /" )
SYSTEM_RELAXED=$(echo "$SYSTEM_RELAXED" | sed "3s/$/\n C = $( expr 2*${c_vct[2]} | bc ) /" )

elif [[ "$ibrav" = "12" ]] ; then
SYSTEM_RELAXED=$(echo "$SYSTEM_RELAXED" | sed "3s/$/\n A = ${a_vct[0]} /" )
SYSTEM_RELAXED=$(echo "$SYSTEM_RELAXED" | sed "3s/$/\n C = ${c_vct[2]} /" )

elif [[ "$ibrav" = "0" ]] ; then
ibrav0=1

else 
echo "This ibrav number is not implemented for sequential simulation. Exiting..."
echo "You will have to input the coordinates for scf/nscf calculation manually."
exit
fi

SYSTEM=$SYSTEM_RELAXED
}

######## FUNCOES PARA CALCULO DE CONVERGENCIA HUBBARD E ETC #####

if [ "$calc_conv" = 1 ] ; then
### Essa funcao elimina o ecutwfc e ecutrho previamente declarados e
### os substitui por argumentos passados para a funcao.
function SYSTEM_CONV_CUTOFF () {
SYSTEM_CONV=$(echo "$SYSTEM" | sed "/ecutwfc/d" )
SYSTEM_CONV=$(echo "$SYSTEM_CONV" | sed "/ecutrho/d" )
SYSTEM_CONV=$(echo "$SYSTEM_CONV" | sed "3s/$/\n ecutwfc=$1 /" )
### ecutrho definido de acordo com o potencial
case $PPtype in
	0)
	ecutrho=$(echo "4*$1" | bc )
	;;
	1)
	ecutrho=$(echo "5*$1" | bc )
	;;
	2)
	ecutrho=$(echo "4*$1" | bc )
	;;
	*)
    echo "Please choose a valid pseudopotential type. 1 for NCPP, 2 for USPP and 3 for PAW."
    exit
    ;;
esac
SYSTEM_CONV=$(echo "$SYSTEM_CONV" | sed "4s/$/\n ecutrho=$ecutrho /" )
}

fi ### fim do calc_conv na declaracao



if [ "$calc_hubbardU" = 1 ] ; then

### Essa funcao pega os valores de U do system e modifica,
### altera ate tres valores de U, os atomos desejados devem estar
### na mesma ordem.
function SYSTEM_HUBBARD_TEST () {
SYSTEM_HUBBARD=$(echo "$SYSTEM" | sed "/Hubbard/d" )
SYSTEM_HUBBARD=$(echo "$SYSTEM_HUBBARD" | sed "/lda_plus_u/d" )
CONTROL=$(echo "$CONTROL" | sed "/tprnfor /d" )
CONTROL=$(echo "$CONTROL" | sed "/tstress /d" )
CONTROL=$(echo "$CONTROL" | sed "1s/$/\n tstress = .true., /" )
CONTROL=$(echo "$CONTROL" | sed "1s/$/\n tprnfor = .true., /" )
SYSTEM_HUBBARD=$(echo "$SYSTEM_HUBBARD" | sed "3s/$/\n lda_plus_u = .true., /" )
SYSTEM_HUBBARD=$(echo "$SYSTEM_HUBBARD" | sed "4s/$/\n Hubbard_U(1) = $1, /" )

## $# e o numero de argumentos passados para a funcao
 if [[ "$#" -gt 1 ]]; then
SYSTEM_HUBBARD=$(echo "$SYSTEM_HUBBARD" | sed "5s/$/\n Hubbard_U(2) = $2, /" )   
 fi
 if [[ "$#" -gt 2 ]]; then
SYSTEM_HUBBARD=$(echo "$SYSTEM_HUBBARD" | sed "6s/$/\n Hubbard_U(3) = $3, /" )
 fi
}

fi ### fim do calc_hubbard na declaracao



### funcao para medir o tempo, usa junto com qualquer comando
tm() {
  s=$(date +%s)
  $@
  rc=$?
  dt=$(echo "$(date +%s)-$s" | bc)
  dd=$(echo "$dt/86400" | bc)
  dt2=$(echo "$dt-86400*$dd" | bc)
  dh=$(echo "$dt2/3600" | bc)
  dt3=$(echo "$dt2-3600*$dh" | bc)
  dm=$(echo "$dt3/60" | bc)
  ds=$(echo "$dt3-60*$dm" | bc)
  printf "Total time spent in $CALC: %d:%02d:%02d:%02.4f\n" $dd $dh $dm $ds >> TIME_SPENT
  return $rc
}

function ADD_MASSES () {
species=$(echo "$ATOMIC_SPECIES" | awk '{if ($2) print $2}' | awk 'END {print NR}')
atomicnumbers=$(echo "$ATOMIC_SPECIES" | awk '{if ($2) print $2}')

j=1
for i in $atomicnumbers ; do
  mass="m_$j"
  eval $mass=$i
  j=$(($j+1))
done

if [[ "$species" -ge 1 ]] ; then
TMP=$(echo "$1" | sed "/amass /d" )
TMP=$(echo "$TMP" | sed "1s/$/\n amass(1) = $m_1, /" )
if [[ "$species" -ge 2 ]] ; then
TMP=$(echo "$TMP" | sed "2s/$/\n amass(2) = $m_2, /" )
if [[ "$species" -ge 3 ]] ; then
TMP=$(echo "$TMP" | sed "3s/$/\n amass(3) = $m_3, /" )
if [[ "$species" -ge 4 ]] ; then
TMP=$(echo "$TMP" | sed "4s/$/\n amass(4) = $m_4, /" )
if [[ "$species" -ge 5 ]] ; then
TMP=$(echo "$TMP" | sed "5s/$/\n amass(5) = $m_5, /" )
if [[ "$species" -ge 6 ]] ; then
TMP=$(echo "$TMP" | sed "6s/$/\n amass(6) = $m_6, /" )
fi
fi
fi
fi
fi
fi
echo $TMP
}

AWS_FURG_SUBMIT() {
if [ "$SERVER" = FURG ] || [ "$SERVER" = AWS ]; then
$MPIRUN $EXEC $PARALLELFLAGS < $INPUT.$CALC.in > out.$INPUT.$CALC
fi
}

UFPEL_SUBMIT() {

if [ "$SERVER" = UFPEL ] ; then

cat > $USUARIO.$INPUT.$CALC.sh << EOF
cd $PASTA
$MPIRUN $EXEC $PARALLELFLAGS < $INPUT.$CALC.in > out.$INPUT.$CALC
EOF
chmod +x $USUARIO.$INPUT.$CALC.sh


### RODAR ###
JOBID=$( qsub $USUARIO.$INPUT.$CALC.sh )

### CHECA SE O CALCULO ESTA RODANDO
while qstat -f $JOBID | grep -q "$INPUT.$CALC" ; do

if $(grep -q "JOB DONE" out.$INPUT.$CALC) ; then 
  echo "Job is hanging, executing qdel..."
  qdel $JOBID 
else 
  sleep 3;
fi

done

#####################################
fi ## server UFPEL
}

CESUP_ADD() {
if [ "$SERVER" = CESUP ] ; then
if [ "$CLUSTER" = GAUSS ] ; then
PARALLELINFO="#PBS -l nodes=1:ppn=$NP"
fi
if [ "$CLUSTER" = NEWTON ] ; then
PARALLELINFO="#PBS -l nodes=1:ppn=$NP"

fi

if [ "$CLUSTER" = FERMI ] ; then
PARALLELINFO="#PBS -l select=$NODES:ncpus=$NP:mpiprocs=$MPINP:ompthreads=$OMPNP:ngpus=2:mem=$MEMORY"
fi


if [ -s "./$USUARIO.$INPUT.sh" ]
then
echo "$MPIRUN $EXEC $PARALLELFLAGS -inp $INPUT.$CALC.in > out.$INPUT.$CALC" >> $USUARIO.$INPUT.sh
else
cat > $USUARIO.$INPUT.sh << EOF
#!/bin/sh
#PBS -S /bin/sh
$PARALLELINFO
#PBS -N $INPUT
#PBS -V
#PBS -j oe
INPUT=$INPUT
$SETTINGS
$MPIRUN $EXEC $PARALLELFLAGS -inp $INPUT.$CALC.in > out.$INPUT.$CALC
EOF
chmod +x $USUARIO.$INPUT.sh
fi

fi
}

CESUP_SUBMIT_ADD() {
if [ "$SERVER" = CESUP ] ; then
JOBID=$( qsub $USUARIO.$INPUT.sh )

### CHECA SE O CALCULO ESTA RODANDO
### CHECA SE O CALCULO ESTA RODANDO
while qstat -f $JOBID | grep -q "$INPUT" ; do

if $(grep -q "JOB DONE" out.$INPUT.$CALC) ; then 
  echo "Job is hanging, executing qdel..."
  qdel $JOBID 
else 
  sleep 3;
fi

done
fi
}


CESUP_SUBMIT() {
if [ "$SERVER" = CESUP ] ; then

if [ "$CLUSTER" = GAUSS ] ; then
PARALLELINFO="#PBS -l nodes=1:ppn=$NP"
fi

if [ "$CLUSTER" = NEWTON ] ; then
PARALLELINFO="#PBS -l nodes=1:ppn=$NP"

fi

if [ "$CLUSTER" = FERMI ] ; then
PARALLELINFO="#PBS -l select=$NODES:ncpus=$NP:mpiprocs=$MPINP:ompthreads=$OMPNP:ngpus=2:mem=$MEMORY"
fi

cat > $USUARIO.$INPUT.$CALC.sh << EOF
#!/bin/sh
#PBS -S /bin/sh
$PARALLELINFO
#PBS -N $INPUT
#PBS -V
#PBS -j oe
INPUT=$INPUT
$SETTINGS
$MPIRUN $EXEC $PARALLELFLAGS < $INPUT.$CALC.in > out.$INPUT.$CALC
# $SETTINGSDATA
EOF
chmod +x $USUARIO.$INPUT.$CALC.sh

### RODAR ###
if [ "$1" != "initialize" ] ; then
JOBID=$( qsub $USUARIO.$INPUT.$CALC.sh )

### CHECA SE O CALCULO ESTA RODANDO
while qstat -f $JOBID | grep -q "$INPUT.$CALC" ; do

if $(grep -q "JOB DONE" out.$INPUT.$CALC) ; then 
  echo "Job is hanging, executing qdel..."
  qdel $JOBID 
else 
  sleep 3;
fi

done

fi

#####################################
fi ## server CESUP
}


SDUMONT_SUBMIT() {
if [ "$SERVER" = SDUMONT ] ; then
NTSK=$(expr $NODES*$NP | bc )
echo $NTSK
PARALLELINFO="
#SBATCH --nodes=$NODES                      # here the number of nodes
#SBATCH --ntasks=$NTSK                    # here total number of mpi tasks
"
INI_SDUMONT="
echo \$SLURM_JOB_NODELIST
cd \$SLURM_SUBMIT_DIR
"

cat > $USUARIO.$INPUT.$CALC.sh << EOF
#!/bin/bash
$PARALLELINFO
## #SBATCH --ntasks-per-node=1            # here ppn = number of process per nodes
#SBATCH -p $FILA                 # target partition
#SBATCH --exclusive                    # to have exclusvie use of your nodes
#SBATCH --job-name=$INPUT
#SBATCH --output=log.txt
#SBATCH --time=3-00:00:00

$INI_SDUMONT
srun $EXEC $PARALLELFLAGS < $INPUT.$CALC.in > out.$INPUT.$CALC

EOF
chmod +x $USUARIO.$INPUT.$CALC.sh

### RODAR ###
if [ "$1" != "initialize" ] ; then
JOBID=$( sbatch $USUARIO.$INPUT.$CALC.sh )
JOBID=$(echo $JOBID | sed 's/[^0-9]//g') ## get job id number
echo $JOBID
### CHECA SE O CALCULO ESTA RODANDO

if [[ -f "out.$INPUT.$CALC" ]]; then ## check if outfile is generated

while sacct | grep $JOBID | grep -q PENDING ; do
if $(grep -q "JOB DONE" out.$INPUT.$CALC) ; then 
  echo "Job is hanging, executing qdel..."
  scancel $JOBID
else 
  sleep 3;
fi
done

while sacct | grep $JOBID | grep -q RUNNING ; do
if $(grep -q "JOB DONE" out.$INPUT.$CALC) ; then
  echo "Job is hanging, executing qdel..."
  scancel $JOBID
else
  sleep 3;
fi
done

else

sleep 60; ## if out file not yet generated

fi ## file exists

fi

#####################################
fi ## server SDUMONT
}


SDUMONT_ADD() {
if [ "$SERVER" = SDUMONT ] ; then
NTSK=$(expr $NODES * $NP | bc )
PARALLELINFO="
#SBATCH --nodes=$NODES                      # here the number of nodes
#SBATCH --ntasks=$NTSK                    # here total number of mpi tasks
"
INI_SDUMONT="
echo \$SLURM_JOB_NODELIST
cd \$SLURM_SUBMIT_DIR
"

if [ -s "./$USUARIO.$INPUT.sh" ]
then
echo "srun $EXEC $PARALLELFLAGS < $INPUT.$CALC.in > out.$INPUT.$CALC" >> $USUARIO.$INPUT.sh
else
cat > $USUARIO.$INPUT.sh << EOF
#!/bin/bash
$PARALLELINFO
## #SBATCH --ntasks-per-node=1            # here ppn = number of process per nodes
#SBATCH -p $FILA                 # target partition
#SBATCH --exclusive                    # to have exclusvie use of your nodes
#SBATCH --job-name=$INPUT
#SBATCH --output=log.txt
## #SBATCH --time=30:00

$INI_SDUMONT
srun $EXEC $PARALLELFLAGS < $INPUT.$CALC.in > out.$INPUT.$CALC
EOF
chmod +x $USUARIO.$INPUT.sh
fi

fi
}

SDUMONT_SUBMIT_ADD() {
if [ "$SERVER" = SDUMONT ] ; then
JOBID=$( sbatch $USUARIO.$INPUT.sh )

### CHECA SE O CALCULO ESTA RODANDO
### CHECA SE O CALCULO ESTA RODANDO
JOBID=$( sbatch $USUARIO.$INPUT.$CALC.sh )
JOBID=$(echo $JOBID | sed 's/[^0-9]//g') ## get job id number

### CHECA SE O CALCULO ESTA RODANDO
while sacct | grep $JOBID | grep -q PENDING ; do
if $(grep -q "JOB DONE" out.$INPUT.$CALC) ; then 
  echo "Job is hanging, executing qdel..."
  scancel $JOBID
else 
  sleep 3;
fi
done

while sacct | grep $JOBID | grep -q RUNNING ; do
if $(grep -q "JOB DONE" out.$INPUT.$CALC) ; then
  echo "Job is hanging, executing qdel..."
  scancel $JOBID
else
  sleep 3;
fi
done


fi
}



#######  ALGUNS SETTINGS IMPORTANTES #########
### PASTA ###
PASTA=$(pwd)

### PASTA DOS PSEUDOPOTENCIAIS ###
if [ "$define_pseudodir" = 1 ] ; then
PSEUDO_DIR=$PSEUDO_DIR
else

if [ "$SERVER" = SDUMONT ] ; then
USER=$USUARIO  ### seu nome de usuario no SDUMONT ###
PSEUDO_DIR="/scratch/lamai/$USER/pseudo"
fi
if [ "$SERVER" = FURG ] ; then
PSEUDO_DIR="/home/mestrado/rogeriog/QE-calculos/pseudos"
fi
if [ "$SERVER" = AWS ] ; then
PSEUDO_DIR="/home/ubuntu/pseudo"
fi
if [ "$SERVER" = UFPEL ] ; then
PSEUDO_DIR="/home/efracio/pseudo"
fi
if [ "$SERVER" = CESUP ] ; then
USER=$USUARIO  ### seu nome de usuario no CESUP ###
PSEUDO_DIR="/home/u/$USER/pseudo"
fi
fi  ## fim pseudodir 

### PASTA DE SAIDA ###
if [ "$define_outdir" = 1 ] ; then
TMP_DIR=$TMP_DIR
else 
if [ "$SERVER" = FURG ] || [ "$SERVER" = UFPEL ] || [ "$SERVER" = AWS ]  ; then
TMP_DIR='./OUTPUT'
fi
if [ "$SERVER" = CESUP ] ; then
TMP_DIR='./OUTPUT'
fi
if [ "$SERVER" = SDUMONT ] ; then
TMP_DIR='./OUTPUT'
fi

fi  ## fim outdir


function QEprog () {
#### EXECUTAVEIS ####
if [ "$SERVER" = SDUMONT ] ; then

EXECDIR="/scratch/lamai/rogerio.gouvea/qe-6.4.1/bin"  ## sera reescrito se QELOCAL
EXEC="$EXECDIR/$1" # sera reescrito se QELOCAL
QEDIR=${EXECDIR%/*}
PWTOOLSDIR="$QEDIR/PW/tools"


if [ "$QELOCAL" != 1 ] ; then
EXECDIR="."
EXEC="$1"
fi

fi #sdumont

if [ "$SERVER" = UFPEL ] ; then
EXECDIR="/home/efracio/qe-6.1/bin"
EXEC="/home/efracio/qe-6.1/bin/$1"
MPIRUN="/home/efracio/openmpi-1.8.5/bin/mpirun -np $NP"
QEDIR="/home/efracio/qe-6.1"
PWTOOLSDIR="$QEDIR/PW/tools"
fi

if [ "$SERVER" = FURG ] ; then
EXECDIR=""
EXEC="$1"
MPIRUN="mpirun --oversubscribe -np $NP"
QEDIR="/home/mestrado/rogeriog/qe-6.4.1"
PWTOOLSDIR="$QEDIR/PW/tools"
fi

if [ "$SERVER" = AWS ] ; then
EXECDIR=""
EXEC="$1"
MPIRUN="mpirun --oversubscribe -np $NP"
QEDIR="/home/ubuntu/q-e-qe-6.5"
PWTOOLSDIR="$QEDIR/PW/tools"
fi


if [ "$SERVER" = CESUP ] ; then
	if [ "$CLUSTER" = GAUSS ] ; then
	EXECDIR="/home/u/$USUARIO/qe-6.4.1/bin"
	EXEC="$EXECDIR/$1"
	MPIRUN="mpiexec"
	QEDIR=${EXECDIR%/*}
	PWTOOLSDIR="$QEDIR/PW/tools"
	fi
	if [ "$CLUSTER" = NEWTON ] ; then
	EXECDIR="/home/u/$USUARIO/qe-6.4.1/bin"
	EXEC="$EXECDIR/$1"
	MPIRUN=""
	QEDIR=${EXECDIR%/*}
	PWTOOLSDIR="$QEDIR/PW/tools"
	fi
	if [ "$CLUSTER" = FERMI ] ; then
#	EXECDIR="/home/u/$USUARIO/qe-6.4.1/bin"
#	EXEC="/home/u/$USUARIO/qe-6.4.1/bin/$1"
	EXECDIR="/opt/local/qe-complete/bin"
	EXEC="$EXECDIR/$1"
	MPIRUN="mpiexec"
        PWTOOLSDIR="/home/u/$USUARIO/qe-6.4.1/PW/tools" 
        QEDIR=${PWTOOLSDIR%/*/*}
  if [ "$fermiGPU" = 1 ] ; then
#    EXECDIR="/opt/local/qe-gpu/bin"
    EXECDIR="/opt/qe/bin"
    EXEC="$EXECDIR/$1"
    MPIRUN="mpiexec"
    PWTOOLSDIR="/home/u/$USUARIO/qe-6.4.1/PW/tools" 
    QEDIR=${PWTOOLSDIR%/*/*}
  fi
  if [ "$fermiLOCAL" = 1 ] ; then
    EXECDIR="/home/u/$USUARIO/qe-6.4.1/bin"
    EXEC="$EXECDIR/$1"
    MPIRUN="mpiexec"
    QEDIR=${EXECDIR%/*}
    PWTOOLSDIR="$QEDIR/PW/tools"
  fi
fi

cat >  settingscluster.tmp << 'EOF'
cd $PBS_O_WORKDIR
# export ESPRESSO_TMPDIR=$SCRATCH/$USER
# if [ ! -d $ESPRESSO_TMPDIR ]; then mkdir -p $ESPRESSO_TMPDIR; fi
# export EXEC=$EXEC
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/acml/ifort64/lib
# export MPI_BUFS_PER_HOST=1024
# export MPI_BUFS_PER_PROC=128
# export MPI_GROUP_MAX=1024
EOF

if [ "$CLUSTER" = NEWTON ] || [ "$CLUSTER" = FERMI ] ; then
### OMP NUM THREADS tem que ser definido para o newton e fermi
echo "export OMP_NUM_THREADS=$OMPNP" >> settingscluster.tmp
SETTINGS=$(cat settingscluster.tmp )
rm settingscluster.tmp
else
### OMP NUM THREADS tem que ser definido para o newton e fermi
echo "export OMP_NUM_THREADS=1" >> settingscluster.tmp
SETTINGS=$(cat settingscluster.tmp )
rm settingscluster.tmp
fi

cat >  settingscluster_compressdata.tmp << 'EOF'
FJOBDONE=$?
JID=$(echo $PBS_JOBID | cut -d\. -f1)
if [ $FJOBDONE -eq 0 ] && [ ! -f CRASH ]; then
        tar czf $PBS_O_WORKDIR/$INPUT\_$JID.tgz --ignore-failed-read $OUTDIR/$INPUT.*save $OUTDIR/_ph0/$INPUT.*save 2> /dev/null
   
cat > remember_to_delete_files_$INPUT << EOFF
 All calculations finished successfuly. Temp files at $ESPRESSO_TMPDIR
EOFF 

else
cat > remember_to_delete_files_$INPUT << EOFF
 The calculations broke before completion. Temp files at $ESPRESSO_TMPDIR
EOFF 
fi
EOF
rm settingscluster_compressdata.tmp
# desativando esse trecho problematico
#SETTINGSDATA=$(cat settingscluster_compressdata.tmp )

fi  ## server cesup settings
}  ## fim do QEprog

### funcao para gerar xsf do input da relaxacao
xsfdist_inrelax () { 
export PATH="$PWTOOLSDIR:$PATH"
$PWTOOLSDIR/pwi2xsf.sh $1 > $INPUT.inputrelax.xsf
$QEDIR/bin/dist.x < $1
mv dist.out dist_initial.out
}

### funcao para gerar xsf do input da relaxacao
xsf_outrelax () { 
$PWTOOLSDIR/pwo2xsf.sh -lc $1 > $INPUT.relaxed.xsf
}
### funcao para gerar dist da saida da relaxacao agora pelo scf.in
dist_outrelax () {
$QEDIR/bin/dist.x < $1
mv dist.out dist_relaxed.out
}


########### para pegar o valor do ibrav e determinar o valor de ibrav0 #####
ibrav=$(echo "$SYSTEM" | grep "ibrav" | awk -F'=' {'print $2'} | sed 's/[^0-9]*//g' )
if [[ "$ibrav" = 0 ]] ; then
ibrav0=1
else
ibrav0=0
fi

##########################################################
#### qual o executavel usado ###
QEprog pw.x
################################


################### CALCULO RELAX ##################

################### CALCULO RELAX ##################

################### CALCULO RELAX ##################

################### CALCULO RELAX ##################
if [ "$calcrelax" = 1 ] ; then

CALC=relax

if [ "$fixcell" = 1 ] ; then
relaxtype="relax"
else
relaxtype="vc-relax"
fi

if [ "$gammapoint" = 1 ] ; then
PARALLELFLAGS="  "  ## para evitar erro da distribuicao de pontos k
cat > $INPUT.$CALC.in << EOF
&CONTROL
  calculation  = "$relaxtype",
  prefix       = "$INPUT",
  pseudo_dir   = "$PSEUDO_DIR",
  outdir       = "$TMP_DIR",
  nstep = 100,
  $CONTROL
/
$SYSTEM
$ELECTRONS
$IONS
$CELL
$ATOMIC_SPECIES
$CELL_AND_ATOMS
K_POINTS {gamma}
EOF
fi

if [ "$kgridrelax" = 1 ] ; then
kr1=${kptgrid_relax[0]}
kr2=${kptgrid_relax[1]}
kr3=${kptgrid_relax[2]}
cat > $INPUT.$CALC.in << EOF
&CONTROL
  calculation  = "$relaxtype",
  prefix       = "$INPUT",
  pseudo_dir   = "$PSEUDO_DIR",
  outdir       = "$TMP_DIR",
  nstep = 100,
  $CONTROL
/
$SYSTEM
$ELECTRONS
$IONS
$CELL
$ATOMIC_SPECIES
$CELL_AND_ATOMS
K_POINTS {automatic}
$kr1 $kr2 $kr3 0 0 0
EOF
fi

echo "  running the $CALC for $INPUT...\c"

tm AWS_FURG_SUBMIT

tm UFPEL_SUBMIT

tm CESUP_SUBMIT

tm SDUMONT_SUBMIT

PARALLELFLAGS=$PARALLELFLAGSini  ## retorna as flags anteriores para calculo com pontos k

xsfdist_inrelax $INPUT.$CALC.in
xsf_outrelax out.$INPUT.$CALC

if grep -q "JOB DONE" out.$INPUT.$CALC ; then 

cp out.$INPUT.$CALC out.$INPUT.relaxed 
SYSTEM_RELAXED
### apos esse comando o system contem agora os parametros de rede relaxados

fi


fi  # fim do calcrelax


################### CALCULO PRESS ##################

################### CALCULO PRESS ##################

################### CALCULO PRESS ##################

################### CALCULO PRESS ##################
if [ "$calcpress" = 1 ] ; then

## restartfromcycle=0
## cyclespressure=20
## pressure_direction="z"
## relaxing_direction="xy"
## pressure=150
## max_displacement=0.1 ## in angstrom
INPUTini=$INPUT
for n in $(seq $restartfromcycle $cyclespressure ) ; do
INPUT=$INPUTini-$n
CALC=press

relaxtype="vc-relax"

CELLpress="&CELL 
 cell_dofree='$pressure_direction',
 press = $pressure,
/
"
CELLrelax="&CELL 
 cell_dofree='$relaxing_direction',
/
"

displacement_ions=$(echo $max_displacement*1.88973 | bc -l )
IONS="&IONS
!  ion_dynamics = 'bfgs',
!  upscale = 1000,
!  bfgs_ndim = 2,
trust_radius_ini = $displacement_ions,
trust_radius_max = $displacement_ions,  
/"

if [[ "$restartfromcycle" -eq "0"  ]] ; then
if [[ "$n" -ne "0" ]] ; then  
### para extrair celula do ciclo anterior
 CELL_AND_ATOMS=$( cat $INPUTOLD-relaxed.coord )   ## takes inputold defined in the end of the cycle.
fi
else     ## restartfromcycle not zero, that is, a restart.
nold=$(($restartfromcycle-1))
INPUTOLD=$INPUTini-$nold
CELL_AND_ATOMS=$( cat $INPUTOLD-relaxed.coord )
restartfromcycle=0  ## this avoids to enter in this restart cycle again
fi


if [ "$gammapoint" = 1 ] ; then
PARALLELFLAGS="  "  ## para evitar erro da distribuicao de pontos k
cat > $INPUT.$CALC.in << EOF
&CONTROL
  calculation  = "$relaxtype",
  prefix       = "$INPUT",
  pseudo_dir   = "$PSEUDO_DIR",
  outdir       = "$TMP_DIR",
  nstep = 1,
  $CONTROL
/
$SYSTEM
$ELECTRONS
$IONS
$CELLpress
$ATOMIC_SPECIES
$CELL_AND_ATOMS
K_POINTS {gamma}
EOF
fi

if [ "$kgridrelax" = 1 ] ; then
kr1=${kptgrid_relax[0]}
kr2=${kptgrid_relax[1]}
kr3=${kptgrid_relax[2]}
cat > $INPUT.$CALC.in << EOF
&CONTROL
  calculation  = "$relaxtype",
  prefix       = "$INPUT",
  pseudo_dir   = "$PSEUDO_DIR",
  outdir       = "$TMP_DIR",
  nstep = 1,
  $CONTROL
/
$SYSTEM
$ELECTRONS
$IONS
$CELLpress
$ATOMIC_SPECIES
$CELL_AND_ATOMS
K_POINTS {automatic}
$kr1 $kr2 $kr3 0 0 0
EOF
fi

echo "  running the $CALC for $INPUT...\c"

tm AWS_FURG_SUBMIT

tm UFPEL_SUBMIT

tm CESUP_SUBMIT

tm SDUMONT_SUBMIT

PARALLELFLAGS=$PARALLELFLAGSini  ## retorna as flags anteriores para calculo com pontos k

### para extrair coordenadas relaxadas
if [[ "$ibrav0" = 1 ]] ; then
nat=$(awk '{if(/number of atoms/) {print $5;exit;}}' out.$INPUT.$CALC)
linhas=$(echo "$nat+5" | bc )
awk -v linhas="$linhas" '/^CELL_PARAMETERS/ {c=1; a=$0;next} c<=linhas{c=c+1;a=a"\n"$0}END{print a}' out.$INPUT.$CALC > $INPUT-relaxed.coord
else
 echo "PRESS CALCULATIONS REQUIRES ibrav=0, UPDATE CELL PARAMETERS AND ATOMIC POSITIONS TO PROCEED! "
 exit
fi

xsfdist_inrelax $INPUT.$CALC.in
xsf_outrelax out.$INPUT.$CALC

CALC=relaxpress

if [ -s "./$INPUT-relaxed.coord" ]
then
    coordrelax=$( cat $INPUT-relaxed.coord )
else
    echo " $INPUT-relaxed.coord empty! Using unrelaxed coordinates."
    coordrelax=$CELL_AND_ATOMS 
fi

if [ "$gammapoint" = 1 ] ; then
PARALLELFLAGS="  "  ## para evitar erro da distribuicao de pontos k
cat > $INPUT.$CALC.in << EOF
&CONTROL
  calculation  = "$relaxtype",
  prefix       = "$INPUT",
  pseudo_dir   = "$PSEUDO_DIR",
  outdir       = "$TMP_DIR",
  nstep = 1,
  $CONTROL
/
$SYSTEM
$ELECTRONS
$IONS
$CELLrelax
$ATOMIC_SPECIES
$coordrelax
K_POINTS {gamma}
EOF
fi

if [ "$kgridrelax" = 1 ] ; then
kr1=${kptgrid_relax[0]}
kr2=${kptgrid_relax[1]}
kr3=${kptgrid_relax[2]}
cat > $INPUT.$CALC.in << EOF
&CONTROL
  calculation  = "$relaxtype",
  prefix       = "$INPUT",
  pseudo_dir   = "$PSEUDO_DIR",
  outdir       = "$TMP_DIR",
  nstep = 1,
/
$SYSTEM
$ELECTRONS
$IONS
$CELLrelax
$ATOMIC_SPECIES
$coordrelax
K_POINTS {automatic}
$kr1 $kr2 $kr3 0 0 0
EOF
fi

echo "  running the $CALC for $INPUT...\c"

tm AWS_FURG_SUBMIT

tm UFPEL_SUBMIT

tm CESUP_SUBMIT

tm SDUMONT_SUBMIT

PARALLELFLAGS=$PARALLELFLAGSini  ## retorna as flags anteriores para calculo com pontos k

### para extrair coordenadas relaxadas
if [[ "$ibrav0" = 1 ]] ; then
nat=$(awk '{if(/number of atoms/) {print $5;exit;}}' out.$INPUT.$CALC)
linhas=$(echo "$nat+5" | bc )
awk -v linhas="$linhas" '/^CELL_PARAMETERS/ {c=1; a=$0;next} c<=linhas{c=c+1;a=a"\n"$0}END{print a}' out.$INPUT.$CALC > $INPUT-relaxed.coord
else
 echo "PRESS CALCULATIONS REQUIRES ibrav=0, UPDATE CELL PARAMETERS AND ATOMIC POSITIONS TO PROCEED! "
 exit
fi


INPUTOLD=$INPUT  ## vai usar esse INPUT para leitura das coordenadas
xsfdist_inrelax $INPUT.$CALC.in
xsf_outrelax out.$INPUT.$CALC

rm -rf ./OUTPUT/$INPUT.*  ## remove todos arquivos gerados

done ## fim do loop do ciclo

fi  # fim do calcpress





################### CALCULO CONVERGENCIA ##################

################### CALCULO CONVERGENCIA ##################

################### CALCULO CONVERGENCIA ##################

################### CALCULO CONVERGENCIA ##################
if [ "$calc_conv" = 1 ] ; then


## com estrutura previamente relaxada se existir.
if [[ -f "out.$INPUT.relax" ]]; then
SYSTEM_RELAXED ## updates SYSTEM with relaxed cell parameters
echo "out.$INPUT.relax exist"
## para extrair nbnd da relaxacao e adicionar 20% para pegar parte da banda de conducao
var=$(awk '{if(/number of Kohn-Sham states=/) {print $5;exit;}}' out.$INPUT.relax)
nbnd=$(echo $var+0.2*$var | bc -l | awk '{print int($1+0.5)}')
### Incluir o NBND!
SYSTEM=$(echo "$SYSTEM" | sed "/nbnd/d" )
SYSTEM=$(echo "$SYSTEM" | sed "3s/$/\n nbnd=$nbnd /" )

### para extrair coordenadas relaxadas
if [[ "$ibrav0" = 1 ]] ; then
nat=$(awk '{if(/number of atoms/) {print $5;exit;}}' out.$INPUT.relax)
linhas=$(echo "$nat+5" | bc )
awk -v linhas="$linhas" '/^CELL_PARAMETERS/ {c=1; a=$0;next} c<=linhas{c=c+1;a=a"\n"$0}END{print a}' out.$INPUT.relax > $INPUT-relaxed.coord
else
nat=$(awk '{if(/number of atoms/) {print $5;exit;}}' out.$INPUT.relax)
awk -v linhas="$nat" '/^ATOMIC_POSITIONS/ {c=1; a=$0;next} c<=linhas{c=c+1;a=a"\n"$0}END{print a}' out.$INPUT.relax > $INPUT-relaxed.coord
fi

if [ -s "./$INPUT-relaxed.coord" ]
then
    coordrelax=$( cat $INPUT-relaxed.coord )
else
	echo " $INPUT-relaxed.coord empty! Using unrelaxed coordinates."
    coordrelax=$CELL_AND_ATOMS 
fi
else
  coordrelax=$CELL_AND_ATOMS 
fi

INPUTini=$INPUT
INPUT=$INPUT-cnv ## precisa mudar para deletar os arquivos depois

### cria folder pp ###
if [ -d ./convergence_test ]; then
  echo "PP folder is already created..."
else
  mkdir convergence_test
fi

cd convergence_test   #### entra na pasta convergence_test
PASTA=$(pwd)   ## atualiza a pasta
touch convergence_ecutwfc.results
echo "ecutwfc  kx ky kz energytmp energytmp_ev " >>  convergence_ecutwfc.results
touch convergence_kgrid.results
echo "ecutwfc  kx ky kz energytmp energytmp_ev " >>  convergence_kgrid.results

### convergencia do cutoff
for ecutwfc in $(seq $ecutwfc_min $ecutwfc_step $ecutwfc_max ) ; do

kx=${kpt_cutoff[0]}
ky=${kpt_cutoff[1]}
kz=${kpt_cutoff[2]}

CALC=conv_ecutwfc_$ecutwfc-kpoints_$kx-$ky-$kz

SYSTEM_CONV_CUTOFF $ecutwfc

if [ "$cutoff_with_gamma" = 1 ] ; then
PARALLELFLAGS="  "  ## para evitar erro da distribuicao de pontos k
cat > $INPUT.$CALC.in << EOF
&CONTROL
  calculation  = "scf",
  prefix       = "$INPUT",
  pseudo_dir   = "$PSEUDO_DIR",
  outdir       = "$TMP_DIR",
  $CONTROL
/
$SYSTEM_CONV
$ELECTRONS
$ATOMIC_SPECIES
$coordrelax
K_POINTS {gamma}
EOF
else
cat > $INPUT.$CALC.in << EOF
&CONTROL
  calculation  = "scf",
  prefix       = "$INPUT",
  pseudo_dir   = "$PSEUDO_DIR",
  outdir       = "$TMP_DIR",
  $CONTROL
/
$SYSTEM_CONV
$ELECTRONS
$ATOMIC_SPECIES
$coordrelax
K_POINTS {automatic}
$kx $ky $kz 0 0 0
EOF
fi

echo "  running the $CALC for $INPUT...\c"

tm AWS_FURG_SUBMIT

tm UFPEL_SUBMIT

#tm CESUP_SUBMIT
tm CESUP_ADD

tm SDUMONT_ADD


done # fim do ecutwfc loop


tm CESUP_SUBMIT_ADD

tm SDUMONT_SUBMIT_ADD

### coletar dados convergencia do cutoff
for ecutwfc in $(seq $ecutwfc_min $ecutwfc_step $ecutwfc_max ) ; do

kx=${kpt_cutoff[0]}
ky=${kpt_cutoff[1]}
kz=${kpt_cutoff[2]}

CALC=conv_ecutwfc_$ecutwfc-kpoints_$kx-$ky-$kz
### para gerar um arquivo com os resultados de convergencia do cutoff
energytmp=$(grep ! out.$INPUT.$CALC | awk '{print $5}')
energytmp_ev=$( echo "$energytmp*13.605698" | bc -l)
echo "$ecutwfc  $kx $ky $kz $energytmp $energytmp_ev " >> convergence_ecutwfc.results

done

### checando a convergencia
### faz a diferenca das energias em ev, e verifica se o valor absoluto e menor que o limiar
### se for menor printa a primeira ocorrencia e sai.
converged_energy_wfc=$( awk 'NR<=2{s=$6;next}{print $1, $2, $3, $4, $5, $6, $6-s;s=$6}' convergence_ecutwfc.results | awk -v thr="$thresold_energydiff" 'function abs(v) {return v < 0 ? -v : v} abs($7)< thr' | awk '{print $1; exit}' )
echo "Total energy in the system is converged for a planewave cutoff of $converged_energy_wfc Ry using a thresold for energy of $thresold_energydiff ." >> convergence_ecutwfc.results


PARALLELFLAGS=$PARALLELFLAGSini  ## retorna as flags anteriores para calculo com pontos k




rm $USUARIO.$INPUT.sh

### convergencia dos kgrid ####
### vai estimar os k sampling em cada direcao a partir das razoes de parametro de rede
invx=$( echo "1/${parameters_ratio[0]}" | bc -l )
invy=$( echo "1/${parameters_ratio[1]}" | bc -l )
invz=$( echo "1/${parameters_ratio[2]}" | bc -l )
for i in $(seq 2 1 $kpts_max ) ; do

kx=$( echo "$invx*$i" | bc -l )
kx=$( ceil $kx )
ky=$( echo "$invy*$i" | bc -l )
ky=$( ceil $ky )
kz=$( echo "$invz*$i" | bc -l )
kz=$( ceil $kz )

#kptmin=${kpts_max[0]}
# Loop through all elements in the array
#for i in "${kpts_max[@]}"
#do
    # Update min if applicable
#    if [[ "$i" -lt "$kptmin" ]]; then
#        kptmin="$i"
#    fi
#done

ecutwfc=$ecutwfc_kpts  ## aqui usa o cutoff determinado para kpoints, seria ideal se fosse o convergido.
CALC=conv_ecutwfc_$ecutwfc-kpoints_$kx-$ky-$kz

SYSTEM_CONV_CUTOFF $ecutwfc

cat > $INPUT.$CALC.in << EOF
&CONTROL
  calculation  = "scf",
  prefix       = "$INPUT",
  pseudo_dir   = "$PSEUDO_DIR",
  outdir       = "$TMP_DIR",
  $CONTROL
/
$SYSTEM_CONV
$ELECTRONS
$ATOMIC_SPECIES
$coordrelax
K_POINTS {automatic}
$kx $ky $kz 0 0 0
EOF

echo "  running the $CALC for $INPUT...\c"

tm AWS_FURG_SUBMIT

tm UFPEL_SUBMIT

tm CESUP_ADD

done # fim do kgrid test loop

tm CESUP_SUBMIT_ADD

tm SDUMONT_SUBMIT_ADD
### para gerar um arquivo com os resultados de convergencia do kgrid
for i in $(seq 2 1 $kpts_max ) ; do

kx=$( echo "$invx*$i" | bc -l )
kx=$( ceil $kx )
ky=$( echo "$invy*$i" | bc -l )
ky=$( ceil $ky )
kz=$( echo "$invz*$i" | bc -l )
kz=$( ceil $kz )

ecutwfc=$ecutwfc_kpts  ## aqui usa o cutoff determinado para kpoints, seria ideal se fosse o convergido.
CALC=conv_ecutwfc_$ecutwfc-kpoints_$kx-$ky-$kz

energytmp=$(grep ! out.$INPUT.$CALC | awk '{print $5}')
energytmp_ev=$( echo "$energytmp*13.605698" | bc -l)
echo "$ecutwfc  $kx $ky $kz $energytmp $energytmp_ev " >>  convergence_kgrid.results

done

### checando a convergencia
### faz a diferenca das energias em ev, e verifica se o valor absoluto e menor que o limiar
### se for menor printa a primeira ocorrencia e sai.
converged_energy_kgrid=$( awk 'NR<=2{s=$6;next}{print $1, $2, $3, $4, $5, $6, $6-s;s=$6}' convergence_kgrid.results | awk -v thr="$thresold_energydiff" 'function abs(v) {return v < 0 ? -v : v} abs($7)< thr' | awk '{print $2, $3, $4; exit}' )
echo "Total energy in the system is converged for a kgrid of $converged_energy_kgrid kpoints using a thresold for energy of $thresold_energydiff ." >> convergence_kgrid.results

rm -rf ./OUTPUT/$INPUT.*  ## remove todos arquivos gerados
INPUT=$INPUTini 
cd ..  ## sair do convergence_test folder
PASTA=$(pwd)
fi  # fim do teste de convergencia











################### CALCULO HUBBARD ##################

################### CALCULO HUBBARD ##################

################### CALCULO HUBBARD ##################

################### CALCULO HUBBARD ##################

################### CALCULO HUBBARD ##################
if [ "$calc_hubbardU" = 1 ] ; then

#### por padrão nao usa a estrutura relaxada, entao se quiser
#### usar a relaxada coloque suas coordenadas manualmente na ficha
#### cell_and_atoms
INPUTini=$INPUT
INPUT=$INPUT.U ## precisa mudar para deletar os arquivos depois

### cria folder pp ###
if [ -d ./hubbard_test ]; then
  echo "PP folder is already created..."
else
  mkdir hubbard_test
fi

cd hubbard_test   #### entra na pasta convergence_test
PASTA=$(pwd)

kx=${kptgrid[0]}
ky=${kptgrid[1]}
kz=${kptgrid[2]}


touch hubbard.results

##### se tiver testando hubbard em 1 elemento.  ########

if [[ "$number_hubbard_sites" -eq 1 ]] ; then
echo "hubbard_1     GAP     TotalForce" >> hubbard.results
### convergencia do cutoff
for hubbardU1 in $(seq $hubbardU1_min $stepU1 $hubbardU1_max ) ; do
CALC=hub_U1_$hubbardU1

SYSTEM_HUBBARD_TEST $hubbardU1 

cat > $INPUT.$CALC.in << EOF
&CONTROL
  calculation  = "scf",
  prefix       = "$INPUT",
  pseudo_dir   = "$PSEUDO_DIR",
  outdir       = "$TMP_DIR",
  $CONTROL
/
$SYSTEM_HUBBARD
$ELECTRONS
$ATOMIC_SPECIES
$CELL_AND_ATOMS
K_POINTS {automatic}
$kx $ky $kz 0 0 0
EOF

echo "  running the $CALC for $INPUT...\c"

tm AWS_FURG_SUBMIT

tm UFPEL_SUBMIT

tm CESUP_SUBMIT

tm SDUMONT_SUBMIT

nkx=${kptgrid_nscf[0]}
nky=${kptgrid_nscf[1]}
nkz=${kptgrid_nscf[2]}

totforce=$(grep "Total force" out.$INPUT.$CALC | awk '{print $4}')
## para extrair nbnd do scf e adicionar 20% para pegar parte da banda de conducao
var=$(awk '{if(/number of Kohn-Sham states=/) {print $5;exit;}}' out.$INPUT.$CALC)
nbnd=$(echo $var+0.2*$var | bc -l | awk '{print int($1+0.5)}')
### Incluir o NBND!
SYSTEM_HUBBARD=$(echo "$SYSTEM_HUBBARD" | sed "/nbnd/d" )
SYSTEM_HUBBARD=$(echo "$SYSTEM_HUBBARD" | sed "3s/$/\n nbnd=$nbnd /" )


CALC=hub_U1_$hubbardU1.nscf


cat > $INPUT.$CALC.in << EOF
&CONTROL
  calculation  = "nscf",
  restart_mode = "restart",
  prefix       = "$INPUT",
  pseudo_dir   = "$PSEUDO_DIR",
  outdir       = "$TMP_DIR",
  $CONTROL

/
$SYSTEM_HUBBARD
$ELECTRONS
$ATOMIC_SPECIES
$CELL_AND_ATOMS 
K_POINTS (automatic)
$nkx $nky $nkz 0 0 0
EOF

echo "  running the $CALC for $INPUT...\c"

tm AWS_FURG_SUBMIT

tm UFPEL_SUBMIT

tm CESUP_SUBMIT

tm SDUMONT_SUBMIT

gap=$(grep highest out.$INPUT.$CALC | awk '{print $8-$7}')
echo "$hubbardU1   $gap   $totforce" >> hubbard.results

done ## close hubbard loop

fi ## end hubbard_sites 1

##### se tiver testando hubbard em 2 elementos.  ########

if [[ "$number_hubbard_sites" -eq 2 ]] ; then
echo "hubbard_1    hubbard_2   GAP     TotalForce" >> hubbard.results
for hubbardU1 in $(seq $hubbardU1_min $stepU1 $hubbardU1_max ) ; do
for hubbardU2 in $(seq $hubbardU2_min $stepU2 $hubbardU2_max ) ; do

CALC=hub_U1_$hubbardU1.U2_$hubbardU2


SYSTEM_HUBBARD_TEST $hubbardU1 $hubbardU2

cat > $INPUT.$CALC.in << EOF
&CONTROL
  calculation  = "scf",
  prefix       = "$INPUT",
  pseudo_dir   = "$PSEUDO_DIR",
  outdir       = "$TMP_DIR",
  $CONTROL
/
$SYSTEM_HUBBARD
$ELECTRONS
$ATOMIC_SPECIES
$CELL_AND_ATOMS
K_POINTS {automatic}
$kx $ky $kz 0 0 0
EOF

echo "  running the $CALC for $INPUT...\c"

tm AWS_FURG_SUBMIT

tm UFPEL_SUBMIT

tm CESUP_SUBMIT

tm SDUMONT_SUBMIT

nkx=${kptgrid_nscf[0]}
nky=${kptgrid_nscf[1]}
nkz=${kptgrid_nscf[2]}

totforce=$(grep "Total force" out.$INPUT.$CALC | awk '{print $4}')

## para extrair nbnd do scf e adicionar 20% para pegar parte da banda de conducao
var=$(awk '{if(/number of Kohn-Sham states=/) {print $5;exit;}}' out.$INPUT.$CALC)
nbnd=$(echo $var+0.2*$var | bc -l | awk '{print int($1+0.5)}')
### Incluir o NBND!
SYSTEM_HUBBARD=$(echo "$SYSTEM_HUBBARD" | sed "/nbnd/d" )
SYSTEM_HUBBARD=$(echo "$SYSTEM_HUBBARD" | sed "3s/$/\n nbnd=$nbnd /" )

CALC=hub_U1_$hubbardU1.U2_$hubbardU2.nscf


cat > $INPUT.$CALC.in << EOF
&CONTROL
  calculation  = "nscf",
  restart_mode = "restart",
  prefix       = "$INPUT",
  pseudo_dir   = "$PSEUDO_DIR",
  outdir       = "$TMP_DIR",
  $CONTROL
/
$SYSTEM_HUBBARD
$ELECTRONS
$ATOMIC_SPECIES
$CELL_AND_ATOMS 
K_POINTS (automatic)
$nkx $nky $nkz 0 0 0
EOF

echo "  running the $CALC for $INPUT...\c"

tm AWS_FURG_SUBMIT

tm UFPEL_SUBMIT

tm CESUP_SUBMIT

tm SDUMONT_SUBMIT


gap=$(grep highest out.$INPUT.$CALC | awk '{print $8-$7}')
echo "$hubbardU1   $hubbardU2  $gap   $totforce" >> hubbard.results


done ## close hubbard1 loop
done ## close hubbard2 loop


fi ## end hubbard sites 2

##### se tiver testando hubbard em 3 elementos.  ########
if [[ "$number_hubbard_sites" -eq 3 ]] ; then
echo "hubbard_1    hubbard_2    hubbard_3     GAP     TotalForce" >> hubbard.results

for hubbardU1 in $(seq $hubbardU1_min $stepU1 $hubbardU1_max ) ; do
for hubbardU2 in $(seq $hubbardU2_min $stepU2 $hubbardU2_max ) ; do
for hubbardU3 in $(seq $hubbardU3_min $stepU3 $hubbardU3_max ) ; do

CALC=hub_U1_$hubbardU1.U2_$hubbardU2.U3_$hubbardU3


SYSTEM_HUBBARD_TEST $hubbardU1 $hubbardU2 $hubbardU3

cat > $INPUT.$CALC.in << EOF
&CONTROL
  calculation  = "scf",
  prefix       = "$INPUT",
  pseudo_dir   = "$PSEUDO_DIR",
  outdir       = "$TMP_DIR",
  $CONTROL
/
$SYSTEM_HUBBARD
$ELECTRONS
$ATOMIC_SPECIES
$CELL_AND_ATOMS
K_POINTS {automatic}
$kx $ky $kz 0 0 0
EOF

echo "  running the $CALC for $INPUT...\c"

tm AWS_FURG_SUBMIT

tm UFPEL_SUBMIT

tm CESUP_SUBMIT

tm SDUMONT_SUBMIT

nkx=${kptgrid_nscf[0]}
nky=${kptgrid_nscf[1]}
nkz=${kptgrid_nscf[2]}

totforce=$(grep "Total force" out.$INPUT.$CALC | awk '{print $4}')
## para extrair nbnd do scf e adicionar 20% para pegar parte da banda de conducao
var=$(awk '{if(/number of Kohn-Sham states=/) {print $5;exit;}}' out.$INPUT.$CALC)
nbnd=$(echo $var+0.2*$var | bc -l | awk '{print int($1+0.5)}')
### Incluir o NBND!
SYSTEM_HUBBARD=$(echo "$SYSTEM_HUBBARD" | sed "/nbnd/d" )
SYSTEM_HUBBARD=$(echo "$SYSTEM_HUBBARD" | sed "3s/$/\n nbnd=$nbnd /" )

CALC=hub_U1_$hubbardU1.U2_$hubbardU2.U3_$hubbardU3.nscf

cat > $INPUT.$CALC.in << EOF
&CONTROL
  calculation  = "nscf",
  restart_mode = "restart",
  prefix       = "$INPUT",
  pseudo_dir   = "$PSEUDO_DIR",
  outdir       = "$TMP_DIR",
  $CONTROL
/
$SYSTEM_HUBBARD
$ELECTRONS
$ATOMIC_SPECIES
$CELL_AND_ATOMS 
K_POINTS (automatic)
$nkx $nky $nkz 0 0 0
EOF

echo "  running the $CALC for $INPUT...\c"

tm AWS_FURG_SUBMIT

tm UFPEL_SUBMIT

tm CESUP_SUBMIT

tm SDUMONT_SUBMIT

gap=$(grep highest out.$INPUT.$CALC | awk '{print $8-$7}')
echo "$hubbardU1   $hubbardU2  $hubbardU3  $gap  $totforce" >> hubbard.results

done ## close hubbard1 loop
done ## close hubbard2 loop
done ## close hubbard3 loop

fi ## end hubbard sites 3

rm -rf ./OUTPUT/$INPUT.*  ## remove todos arquivos gerados
INPUT=$INPUTini 
cd .. ## sair do hubbard_test
PASTA=$(pwd)
fi ## fim do teste de hubbard







################### CALCULO SCF #####################

################### CALCULO SCF #####################

################### CALCULO SCF #####################

################### CALCULO SCF #####################

if [ "$calcscf" = 1 ] ; then


CALC=scf
kx=${kptgrid[0]}
ky=${kptgrid[1]}
kz=${kptgrid[2]}


shiftx=0
shifty=0
shiftz=0

if [ "$gridshift_scf" = 1 ] ; then
shiftx=1
shifty=1
shiftz=1
fi

## com estrutura previamente relaxada se existir.
if [[ -f "out.$INPUT.relax" ]]; then

##### caso o script relax caia antes de terminar precisa executar essas linhas
xsfdist_inrelax $INPUT.relax.in
xsf_outrelax out.$INPUT.relax
cp out.$INPUT.relax out.$INPUT.relaxed
#####

SYSTEM_RELAXED
echo "out.$INPUT.relax exist"
## para extrair nbnd da relaxacao e adicionar 20% para pegar parte da banda de conducao
var=$(awk '{if(/number of Kohn-Sham states=/) {print $5;exit;}}' out.$INPUT.relax)
nbnd=$(echo $var+0.2*$var | bc -l | awk '{print int($1+0.5)}')
### Incluir o NBND!
SYSTEM=$(echo "$SYSTEM" | sed "/nbnd/d" )
SYSTEM=$(echo "$SYSTEM" | sed "3s/$/\n nbnd=$nbnd /" )

### para extrair coordenadas relaxadas
if [[ "$ibrav0" = 1 ]] ; then
nat=$(awk '{if(/number of atoms/) {print $5;exit;}}' out.$INPUT.relax)
linhas=$(echo "$nat+5" | bc )
awk -v linhas="$linhas" '/^CELL_PARAMETERS/ {c=1; a=$0;next} c<=linhas{c=c+1;a=a"\n"$0}END{print a}' out.$INPUT.relax > $INPUT-relaxed.coord
else
nat=$(awk '{if(/number of atoms/) {print $5;exit;}}' out.$INPUT.relax)
awk -v linhas="$nat" '/^ATOMIC_POSITIONS/ {c=1; a=$0;next} c<=linhas{c=c+1;a=a"\n"$0}END{print a}' out.$INPUT.relax > $INPUT-relaxed.coord
fi


if [ -s "./$INPUT-relaxed.coord" ]
then
    coordrelax=$( cat $INPUT-relaxed.coord )
else
    echo " $INPUT-relaxed.coord empty! Using unrelaxed coordinates."
    coordrelax=$CELL_AND_ATOMS 
fi
else
  coordrelax=$CELL_AND_ATOMS 
fi


cat > $INPUT.$CALC.in << EOF
&CONTROL
  calculation  = "scf",
  prefix       = "$INPUT",
  pseudo_dir   = "$PSEUDO_DIR",
  outdir       = "$TMP_DIR",
  $CONTROL
/
$SYSTEM
$ELECTRONS
$ATOMIC_SPECIES
$coordrelax
K_POINTS (automatic)
$kx $ky $kz $shiftx $shifty $shiftz
EOF

if [ "$bandshybrid" = 1 ] ; then
cat > $INPUT.$CALC.in << EOF
&CONTROL
  calculation  = "scf",
  prefix       = "$INPUT",
  pseudo_dir   = "$PSEUDO_DIR",
  outdir       = "$TMP_DIR",
  $CONTROL
/
$SYSTEM
$ELECTRONS
$ATOMIC_SPECIES
$coordrelax
$BANDS
EOF

fi

echo "  running the $CALC for $INPUT...\c"

tm AWS_FURG_SUBMIT

tm UFPEL_SUBMIT

tm CESUP_SUBMIT

tm SDUMONT_SUBMIT

dist_outrelax $INPUT.$CALC.in

fi ## fim do scf













################### CALCULO NSCF #####################

################### CALCULO NSCF #####################

################### CALCULO NSCF #####################

################### CALCULO NSCF #####################

################### CALCULO NSCF #####################

if [ "$calcnscf" = 1 ] ; then

CALC=nscf
nkx=${kptgrid_nscf[0]}
nky=${kptgrid_nscf[1]}
nkz=${kptgrid_nscf[2]}

nshiftx=0
nshifty=0
nshiftz=0

if [ "$gridshift_nscf" = 1 ] ; then
nshiftx=1
nshifty=1
nshiftz=1
fi

## com estrutura previamente relaxada se existir.
if [[ -f "out.$INPUT.relax" ]]; then
echo "out.$INPUT.relax exist"

##### caso o script relax caia antes de terminar precisa executar essas linhas
xsfdist_inrelax $INPUT.relax.in
xsf_outrelax out.$INPUT.relax
cp out.$INPUT.relax out.$INPUT.relaxed
#####

SYSTEM_RELAXED
echo "out.$INPUT.relax exist"


### para extrair coordenadas relaxadas
if [[ "$ibrav0" = 1 ]] ; then
nat=$(awk '{if(/number of atoms/) {print $5;exit;}}' out.$INPUT.relax)
linhas=$(echo "$nat+5" | bc )
awk -v linhas="$linhas" '/^CELL_PARAMETERS/ {c=1; a=$0;next} c<=linhas{c=c+1;a=a"\n"$0}END{print a}' out.$INPUT.relax > $INPUT-relaxed.coord
else
nat=$(awk '{if(/number of atoms/) {print $5;exit;}}' out.$INPUT.relax)
awk -v linhas="$nat" '/^ATOMIC_POSITIONS/ {c=1; a=$0;next} c<=linhas{c=c+1;a=a"\n"$0}END{print a}' out.$INPUT.relax > $INPUT-relaxed.coord
fi


if [ -s "./$INPUT-relaxed.coord" ]
then
    coordrelax=$( cat $INPUT-relaxed.coord )
else
	echo " $INPUT-relaxed.coord empty! Using unrelaxed coordinates."
    coordrelax=$CELL_AND_ATOMS 
fi
else
  coordrelax=$CELL_AND_ATOMS 
fi

## para extrair nbnd da relaxacao e adicionar 20% para pegar parte da banda de conducao
var=$(awk '{if(/number of Kohn-Sham states=/) {print $5;exit;}}' out.$INPUT.scf)
nbnd=$(echo $var+0.2*$var | bc -l | awk '{print int($1+0.5)}')
#### Incluir o NBND!
SYSTEM=$(echo "$SYSTEM" | sed "/nbnd/d" )
SYSTEM=$(echo "$SYSTEM" | sed "3s/$/\n nbnd=$nbnd /" )

cat > $INPUT.nscf.in << EOF
&CONTROL
  calculation  = "nscf",
  restart_mode = "restart",
  prefix       = "$INPUT",
  pseudo_dir   = "$PSEUDO_DIR",
  outdir       = "$TMP_DIR",
  $CONTROL
/
$SYSTEM
$ELECTRONS
$ATOMIC_SPECIES
$coordrelax
K_POINTS (automatic)
$nkx $nky $nkz $nshiftx $nshifty $nshiftz
EOF

echo "  running the $CALC for $INPUT...\c"

tm AWS_FURG_SUBMIT

tm UFPEL_SUBMIT

tm CESUP_SUBMIT

tm SDUMONT_SUBMIT


gap=$(grep highest out.$INPUT.nscf | awk '{print $8-$7}')
cat > gap_nscf << EOF
$gap
EOF

fi ## fim nscf











################### CALCULO BANDS #####################

################### CALCULO BANDS #####################

################### CALCULO BANDS #####################

################### CALCULO BANDS #####################

################### CALCULO BANDS #####################

if [ "$calcbands" = 1 ] ; then
CALC=bands
## com estrutura previamente relaxada se existir.
if [[ -f "out.$INPUT.relax" ]]; then
echo "out.$INPUT.relax exist"

### para extrair coordenadas relaxadas
if [[ "$ibrav0" = 1 ]] ; then
nat=$(awk '{if(/number of atoms/) {print $5;exit;}}' out.$INPUT.relax)
linhas=$(echo "$nat+5" | bc )
awk -v linhas="$linhas" '/^CELL_PARAMETERS/ {c=1; a=$0;next} c<=linhas{c=c+1;a=a"\n"$0}END{print a}' out.$INPUT.relax > $INPUT-relaxed.coord
else
nat=$(awk '{if(/number of atoms/) {print $5;exit;}}' out.$INPUT.relax)
awk -v linhas="$nat" '/^ATOMIC_POSITIONS/ {c=1; a=$0;next} c<=linhas{c=c+1;a=a"\n"$0}END{print a}' out.$INPUT.relax > $INPUT-relaxed.coord
fi


if [ -s "./$INPUT-relaxed.coord" ]
then
    coordrelax=$( cat $INPUT-relaxed.coord )
else
    echo " $INPUT-relaxed.coord empty! Using unrelaxed coordinates."
    coordrelax=$CELL_AND_ATOMS 
fi
else
  coordrelax=$CELL_AND_ATOMS 
fi

## para extrair nbnd da relaxacao e adicionar 20% para pegar parte da banda de conducao
var=$(awk '{if(/number of Kohn-Sham states=/) {print $5;exit;}}' out.$INPUT.scf)
nbnd=$(echo $var+0.2*$var | bc -l | awk '{print int($1+0.5)}')
### Incluir o NBND!
SYSTEM=$(echo "$SYSTEM" | sed "/nbnd=/d" )
SYSTEM=$(echo "$SYSTEM" | sed "3s/$/\n nbnd=$nbnd /" )


## DESCOMENTA SE QUISER TIRAR O TRECHO A SEGUIR
cat > $INPUT.$CALC.in << EOF
&CONTROL
  calculation  = "bands",
  restart_mode = "restart",
  prefix       = "$INPUT",
  pseudo_dir   = "$PSEUDO_DIR",
  outdir       = "$TMP_DIR",
  $CONTROL
/
$SYSTEM
$ELECTRONS
$ATOMIC_SPECIES
$coordrelax
$BANDS

EOF

echo "  running the $CALC for $INPUT...\c"

tm AWS_FURG_SUBMIT

tm UFPEL_SUBMIT

tm CESUP_SUBMIT

tm SDUMONT_SUBMIT

fi ## fim bands











##################  POS PROCESSAMENTO #####################

##################  POS PROCESSAMENTO #####################

##################  POS PROCESSAMENTO #####################

##################  POS PROCESSAMENTO #####################

##################  POS PROCESSAMENTO #####################
if [ "$calcPP" = 1 ] ; then
fermiGPU=0  ### nao tem esse modulo para gpu

CALC=pp

### no CESUP vai precisar descomprimir o arquivo ###
#if [ "$SERVER" = CESUP ] ; then
#tar xzf $INPUT_*.tgz
#fi

###
HOMO_band=$(awk '{if(/number of electrons/) {print $5;exit;}}' out.$INPUT.scf )
HOMO_band=$(echo "scale=0; $HOMO_band / 2" | bc -l)
LUMO_band=$((HOMO_band+1))
kpointsNSCF=$(awk '{if(/number of k points=/) {print $5;exit;}}' out.$INPUT.nscf )

### cria folder pp ###
if [ -d ./PP ]; then
  echo "PP folder is already created..."
else
  mkdir PP
fi

#### DOS ####
cat > ./PP/$INPUT.dos.in << EOF
&dos  
prefix = '$INPUT' 
outdir = '$TMP_DIR'  
ngauss = 0
Emin=-24,  Emax=24, DeltaE=0.001
fildos='./PP/$INPUT.dos'
/
EOF
#### DENSIDADE DE CARGA XSF #####
cat > ./PP/$INPUT.charge3d.in << EOF
&inputpp
prefix = '$INPUT' 
outdir = './OUTPUT'  
filplot = './PP/$INPUT.charge'
plot_num = 0
/
&plot
nfile = 1
filepp(1) = './PP/$INPUT.charge'
weight(1) = 1.0
iflag = 3
output_format = 5
fileout = './PP/$INPUT.charge.xsf'
/
EOF
#### DENSIDADE DE SPIN CUBE #####
cat > ./PP/$INPUT.spol3d.in << EOF
&inputpp
prefix = '$INPUT' 
outdir = './OUTPUT'  
filplot = './PP/$INPUT.spol'
plot_num = 6
/
&plot
nfile = 1
filepp(1) = './PP/$INPUT.spol'
weight(1) = 1.0
iflag = 3
output_format = 6
fileout = './PP/$INPUT.spol.cube'
/
EOF
####  POTENCIAL TOTAL  #####
cat > ./PP/$INPUT.Vtotal.in << EOF
&inputpp
prefix = '$INPUT' 
outdir = './OUTPUT'  
filplot = './PP/$INPUT.vtot'
plot_num = 1
/
&plot
nfile = 1
filepp(1) = './PP/$INPUT.vtot'
weight(1) = 1.0
iflag = 3
output_format = 6
fileout = './PP/$INPUT.vtot.cube'
/
EOF
##### DENSIDADE DE CARGA ANALISE DE BADER #####
cat > ./PP/$INPUT.charge-cube.in << EOF
&inputpp
/
&plot
nfile = 1
filepp(1) = './PP/$INPUT.charge'
weight(1) = 1.0
iflag = 3
output_format = 6
fileout = './PP/$INPUT.charge.cube'
/
EOF

##### INPUT PARA PLOTAR HOMO LUMO ####

cat > ./PP/$INPUT.HOMO.in << EOF
&inputpp
 prefix ='$INPUT',
 outdir = './OUTPUT'  
filplot = './PP/$INPUT.HOMO'
plot_num = 7
 kpoint = 1,
! kpoint(2) = $kpointsNSCF,
 kband = $HOMO_band,   
/
&plot
 nfile= 1,
 filepp(1)='./PP/$INPUT.HOMO',
 weight(1)= 1.0,
 iflag= 3,
 output_format=6, 
 fileout='./PP/$INPUT.HOMO.cube'
/
EOF

cat > ./PP/$INPUT.LUMO.in << EOF
&inputpp
 prefix ='$INPUT',
 outdir = './OUTPUT'  
filplot = './PP/$INPUT.LUMO'
plot_num = 7
 kpoint = 1,
! kpoint(2) = $kpointsNSCF,
 kband = $LUMO_band,   
/
&plot
 nfile= 1,
 filepp(1)='./PP/$INPUT.LUMO',
 weight(1)= 1.0,
 iflag= 3,
 output_format=6,  
 fileout='./PP/$INPUT.LUMO.cube'
/
EOF

#### BANDS  ############
cat > ./PP/$INPUT.bands.in << EOF
&bands
prefix = '$INPUT' 
outdir = './OUTPUT'  
filband = './PP/band_$INPUT.dat'
/
EOF

### cria folder pdos ###
if [ -d ./PP/PDOS ]; then
  echo "PP/PDOS folder is already created..."
else
  mkdir ./PP/PDOS
fi

##### Partial DOS  #####
cat > ./PP/$INPUT.pdos.in << EOF
&projwfc
prefix = '$INPUT' 
outdir = './OUTPUT'  
ngauss = 0
Emin=-24,  Emax=24, DeltaE=0.001
filpdos='./PP/PDOS/$INPUT'
/
EOF

if [ "$calcbands" = 1 ] ; then
##### Partial DOS  #####
cat > ./PP/$INPUT.pdos.in << EOF
&projwfc
prefix = '$INPUT' 
outdir = './OUTPUT'  
ngauss = 0
kresolveddos = .true.
Emin=-24,  Emax=24, DeltaE=0.001
filpdos='./PP/PDOS/$INPUT'
/
EOF
fi

echo "Preparing qsub to run calculation..."

QEprog .


if [ "$SERVER" = SDUMONT ] ; then
SDUMONT_SUBMIT initialize

PARALLELINFO="
#SBATCH --nodes=$NODES                      # here the number of nodes
#SBATCH --ntasks=$NP                     # here total number of mpi tasks
"
INI_SDUMONT="
echo \$SLURM_JOB_NODELIST
cd \$SLURM_SUBMIT_DIR
"

cat > $USUARIO.$INPUT.$CALC.sh << EOF
#!/bin/bash
## #SBATCH --ntasks-per-node=1            # here ppn = number of process per nodes
$PARALLELINFO
#SBATCH -p $FILA                 # target partition
#SBATCH --exclusive                    # to have exclusvie use of your nodes
#SBATCH --job-name=$INPUT
#SBATCH --output=log.txt
## #SBATCH --time=30:00

$INI_SDUMONT
srun $EXEC $PARALLELFLAGS < $INPUT.$CALC.in > out.$INPUT.$CALC
srun $EXECDIR/dos.x < ./PP/$INPUT.dos.in > ./PP/out.$INPUT.dos
srun $EXECDIR/pp.x < ./PP/$INPUT.charge3d.in > ./PP/out.$INPUT.charge3d
srun $EXECDIR/pp.x < ./PP/$INPUT.spol3d.in > ./PP/out.$INPUT.spol3d
srun $EXECDIR/pp.x < ./PP/$INPUT.Vtotal.in > ./PP/out.$INPUT.Vtotal
srun $EXECDIR/pp.x < ./PP/$INPUT.charge-cube.in > ./PP/out.$INPUT.charge-cube
srun $EXECDIR/pp.x < ./PP/$INPUT.HOMO.in > ./PP/out.$INPUT.HOMO
srun $EXECDIR/pp.x < ./PP/$INPUT.LUMO.in > ./PP/out.$INPUT.LUMO
srun $EXECDIR/projwfc.x $PARALLELFLAGS < ./PP/$INPUT.pdos.in > ./PP/out.$INPUT.pdos

EOF
chmod +x $USUARIO.$INPUT.$CALC.sh

### RODAR ###
JOBID=$( sbatch $USUARIO.$INPUT.$CALC.sh )
JOBID=$(echo $JOBID | sed 's/[^0-9]//g') ## get job id number

### CHECA SE O CALCULO ESTA RODANDO
while sacct | grep $JOBID | grep -q PENDING ; do
if $(grep -q "JOB DONE" out.$INPUT.$CALC) ; then 
  echo "Job is hanging, executing qdel..."
  scancel $JOBID
else 
  sleep 3;
fi
done

while sacct | grep $JOBID | grep -q RUNNING ; do
if $(grep -q "JOB DONE" out.$INPUT.$CALC) ; then
  echo "Job is hanging, executing qdel..."
  scancel $JOBID
else
  sleep 3;
fi
done



if [ "$calcbands" = 1 ] ; then

cat > $USUARIO.$INPUT.bnd.sh << EOF
#!/bin/bash
$PARALLELINFO
## #SBATCH --ntasks-per-node=1            # here ppn = number of process per nodes
#SBATCH -p $FILA                 # target partition
#SBATCH --exclusive                    # to have exclusvie use of your nodes
#SBATCH --job-name=$INPUT
#SBATCH --output=log.txt
## #SBATCH --time=30:00

$INI_SDUMONT
srun $EXECDIR/bands.x < ./PP/$INPUT.bands.in > ./PP/out.$INPUT.bands

EOF
### RODAR ###
JOBID=$( sbatch $USUARIO.$INPUT.bnd.sh )


### CHECA SE O CALCULO ESTA RODANDO
while squeue -j $JOBID | grep -q "$INPUT.bnd" ; do

if $(grep -q "JOB DONE" ./PP/out.$INPUT.bands) ; then 
  echo "Job is hanging, executing qdel..."
  scancel $JOBID 
else 
  sleep 3;
fi
done

fi #bandss

fi #sdumont



if [ "$SERVER" = CESUP ] ; then
CESUP_SUBMIT initialize

if [ "$CLUSTER" = GAUSS ] || [ "$CLUSTER" = FERMI ] ; then
cat > $USUARIO.$INPUT.$CALC.sh << EOF
#!/bin/sh
#PBS -S /bin/sh
$PARALLELINFO
#PBS -N $INPUT.$CALC
#PBS -j oe
INPUT=$INPUT
$SETTINGS
$MPIRUN $EXECDIR/dos.x -inp ./PP/$INPUT.dos.in > ./PP/out.$INPUT.dos
$MPIRUN $EXECDIR/pp.x < ./PP/$INPUT.charge3d.in > ./PP/out.$INPUT.charge3d
$MPIRUN $EXECDIR/pp.x < ./PP/$INPUT.spol3d.in > ./PP/out.$INPUT.spol3d
$MPIRUN $EXECDIR/pp.x < ./PP/$INPUT.Vtotal.in > ./PP/out.$INPUT.Vtotal
$MPIRUN $EXECDIR/pp.x < ./PP/$INPUT.charge-cube.in > ./PP/out.$INPUT.charge-cube
$MPIRUN $EXECDIR/pp.x < ./PP/$INPUT.HOMO.in > ./PP/out.$INPUT.HOMO
$MPIRUN $EXECDIR/pp.x < ./PP/$INPUT.LUMO.in > ./PP/out.$INPUT.LUMO
$MPIRUN $EXECDIR/projwfc.x $PARALLELFLAGS < ./PP/$INPUT.pdos.in > ./PP/out.$INPUT.pdos

EOF
### RODAR ###
JOBID=$( qsub $USUARIO.$INPUT.$CALC.sh )

### CHECA SE O CALCULO ESTA RODANDO
while qstat -f $JOBID | grep -q "$INPUT.$CALC" ; do

if $(grep -q "JOB DONE" out.$INPUT.$CALC) ; then 
  echo "Job is hanging, executing qdel..."
  qdel $JOBID 
else 
  sleep 3;
fi
done



if [ "$calcbands" = 1 ] ; then

cat > $USUARIO.$INPUT.bnd.sh << EOF
#!/bin/sh
#PBS -S /bin/sh
$PARALLELINFO
#PBS -N $INPUT.bnd
#PBS -j oe
INPUT=$INPUT
$SETTINGS
$MPIRUN $EXECDIR/bands.x < ./PP/$INPUT.bands.in > ./PP/out.$INPUT.bands

EOF
### RODAR ###
JOBID=$( qsub $USUARIO.$INPUT.bnd.sh )


### CHECA SE O CALCULO ESTA RODANDO
while qstat -f $JOBID | grep -q "$INPUT.bnd" ; do

if $(grep -q "JOB DONE" ./PP/out.$INPUT.bands) ; then 
  echo "Job is hanging, executing qdel..."
  qdel $JOBID 
else 
  sleep 3;
fi
done

fi # calcbands

fi # cluster


if [ "$CLUSTER" = NEWTON ] ; then
cd PP
CALC=dos
QEprog dos.x
tm CESUP_SUBMIT

CALC=bands
QEprog bands.x
tm CESUP_SUBMIT

CALC=charge3d
QEprog pp.x
tm CESUP_SUBMIT

CALC=charge-cube
QEprog pp.x
tm CESUP_SUBMIT

CALC=HOMO
QEprog pp.x
tm CESUP_SUBMIT

CALC=LUMO
QEprog pp.x
tm CESUP_SUBMIT

CALC=pdos
QEprog projwfc.x
tm CESUP_SUBMIT
 
cd ..
fi ## end newton

fi ## end server cesup

if [ "$SERVER" = UFPEL ] ; then
cat > $USUARIO.$INPUT.$CALC.sh << EOF
cd $PASTA
$MPIRUN $EXECDIR/dos.x < ./PP/$INPUT.dos.in > ./PP/out.$INPUT.dos
# $MPIRUN $EXECDIR/bands.x < ./PP/$INPUT.bands.in > ./PP/out.$INPUT.bands
$MPIRUN $EXECDIR/pp.x < ./PP/$INPUT.charge3d.in > ./PP/out.$INPUT.charge3d
$MPIRUN $EXECDIR/pp.x < ./PP/$INPUT.spol3d.in > ./PP/out.$INPUT.spol3d
$MPIRUN $EXECDIR/pp.x < ./PP/$INPUT.Vtotal.in > ./PP/out.$INPUT.Vtotal
$MPIRUN $EXECDIR/pp.x < ./PP/$INPUT.charge-cube.in > ./PP/out.$INPUT.charge-cube
$MPIRUN $EXECDIR/pp.x < ./PP/$INPUT.HOMO.in > ./PP/out.$INPUT.HOMO
$MPIRUN $EXECDIR/pp.x < ./PP/$INPUT.LUMO.in > ./PP/out.$INPUT.LUMO
$MPIRUN $EXECDIR/projwfc.x $PARALLELFLAGS < ./PP/$INPUT.pdos.in > ./PP/out.$INPUT.pdos

EOF
### RODAR ###
JOBID=$( qsub $USUARIO.$INPUT.$CALC.sh )

### CHECA SE O CALCULO ESTA RODANDO
while qstat -f $JOBID | grep -q "$INPUT.$CALC" ; do

if $(grep -q "JOB DONE" out.$INPUT.$CALC) ; then 
  echo "Job is hanging, executing qdel..."
  qdel $JOBID 
else 
  sleep 3;
fi
done


if [ "$calcbands" = 1 ] ; then

cat > $USUARIO.$INPUT.bnd.sh << EOF
#!/bin/sh
#PBS -S /bin/sh
$PARALLELINFO
#PBS -N $INPUT.bnd
#PBS -j oe
INPUT=$INPUT
$SETTINGS
$MPIRUN $EXECDIR/bands.x < ./PP/$INPUT.bands.in > ./PP/out.$INPUT.bands

EOF
### RODAR ###
JOBID=$( qsub $USUARIO.$INPUT.$CALC.sh )


### CHECA SE O CALCULO ESTA RODANDO
while qstat -f $JOBID | grep -q "$INPUT.bnd" ; do
if $(grep -q "JOB DONE" out.$INPUT.bnd) ; then 
  echo "Job is hanging, executing qdel..."
  qdel $JOBID 
else 
  sleep 3;
fi
done

fi


fi ## end server ufpel

if [ "$SERVER" = FURG ] || [ "$SERVER" = AWS ] ; then
$MPIRUN dos.x < ./PP/$INPUT.dos.in > ./PP/out.$INPUT.dos


if [ "$calcbands" = 1 ] ; then
$MPIRUN bands.x < ./PP/$INPUT.bands.in > ./PP/out.$INPUT.bands
fi

$MPIRUN pp.x < ./PP/$INPUT.charge3d.in > ./PP/out.$INPUT.charge3d
$MPIRUN pp.x < ./PP/$INPUT.spol3d.in > ./PP/out.$INPUT.spol3d
$MPIRUN pp.x < ./PP/$INPUT.Vtotal.in > ./PP/out.$INPUT.Vtotal
$MPIRUN pp.x < ./PP/$INPUT.charge-cube.in > ./PP/out.$INPUT.charge-cube
$MPIRUN projwfc.x $PARALLELFLAGS < ./PP/$INPUT.pdos.in > ./PP/out.$INPUT.pdos
fi

 
fi ## fim PP




##################  ANALISE DE BADER #####################

##################  ANALISE DE BADER #####################

##################  ANALISE DE BADER #####################

##################  ANALISE DE BADER #####################

##################  ANALISE DE BADER #####################
if [ "$calcbader" = 1 ] ; then
fermiGPU=0  ### nao tem esse modulo para gpu

# if $bader_path ./PP/$INPUT.charge.cube ; then
#	echo "Bader analysis was probably successful."
if [[ -f "./$INPUT-ACF.dat" ]] ; then
	echo "Bader analysis was probably successful."
else 
	wget http://theory.cm.utexas.edu/henkelman/code/bader/download/bader_lnx_64.tar.gz
	tar -xzvf bader_lnx_64.tar.gz
	./bader ./PP/$INPUT.charge.cube
	echo "Bader analysis was probably successful now."
fi

mv ACF.dat $INPUT-ACF.dat
mv AVF.dat $INPUT-AVF.dat
mv BCF.dat $INPUT-BCF.dat

fi ## fim da analise de bader


##################  POS PROCESSAMENTO PYTHON #####################

##################  POS PROCESSAMENTO PYTHON #####################

##################  POS PROCESSAMENTO PYTHON #####################

##################  POS PROCESSAMENTO PYTHON #####################

##################  POS PROCESSAMENTO PYTHON #####################
if [ "$PPpython" = 1 ] ; then
fermiGPU=0  ### nao tem outros modulos para gpu

if [ "$bandshybrid" = 1 ] ; then
cat > bandshybrid.py << 'EOF'
import re
import matplotlib.pyplot as plt
import numpy as np
from math import sqrt
#from scipy.interpolate import interp1d

#import numpy as np
#from math import sqrt

def cubic_interp1d(x0, x, y):
    """
    Interpolate a 1-D function using cubic splines.
      x0 : a float or an 1d-array
      x : (N,) array_like
          A 1-D array of real/complex values.
      y : (N,) array_like
          A 1-D array of real values. The length of y along the
          interpolation axis must be equal to the length of x.

    Implement a trick to generate at first step the cholesky matrice L of
    the tridiagonal matrice A (thus L is a bidiagonal matrice that
    can be solved in two distinct loops).

    additional ref: www.math.uh.edu/~jingqiu/math4364/spline.pdf 
    """
    x = np.asfarray(x)
    y = np.asfarray(y)

    # remove non finite values
    # indexes = np.isfinite(x)
    # x = x[indexes]
    # y = y[indexes]

    # check if sorted
    if np.any(np.diff(x) < 0):
        indexes = np.argsort(x)
        x = x[indexes]
        y = y[indexes]

    size = len(x)

    xdiff = np.diff(x)
    ydiff = np.diff(y)

    # allocate buffer matrices
    Li = np.empty(size)
    Li_1 = np.empty(size-1)
    z = np.empty(size)

    # fill diagonals Li and Li-1 and solve [L][y] = [B]
    Li[0] = sqrt(2*xdiff[0])
    Li_1[0] = 0.0
    B0 = 0.0 # natural boundary
    z[0] = B0 / Li[0]

    for i in range(1, size-1, 1):
        Li_1[i] = xdiff[i-1] / Li[i-1]
        Li[i] = sqrt(2*(xdiff[i-1]+xdiff[i]) - Li_1[i-1] * Li_1[i-1])
        Bi = 6*(ydiff[i]/xdiff[i] - ydiff[i-1]/xdiff[i-1])
        z[i] = (Bi - Li_1[i-1]*z[i-1])/Li[i]

    i = size - 1
    Li_1[i-1] = xdiff[-1] / Li[i-1]
    Li[i] = sqrt(2*xdiff[-1] - Li_1[i-1] * Li_1[i-1])
    Bi = 0.0 # natural boundary
    z[i] = (Bi - Li_1[i-1]*z[i-1])/Li[i]

    # solve [L.T][x] = [y]
    i = size-1
    z[i] = z[i] / Li[i]
    for i in range(size-2, -1, -1):
        z[i] = (z[i] - Li_1[i-1]*z[i+1])/Li[i]

    # find index
    index = x.searchsorted(x0)
    np.clip(index, 1, size-1, index)

    xi1, xi0 = x[index], x[index-1]
    yi1, yi0 = y[index], y[index-1]
    zi1, zi0 = z[index], z[index-1]
    hi1 = xi1 - xi0

    # calculate cubic
    f0 = zi0/(6*hi1)*(xi1-x0)**3 + \
         zi1/(6*hi1)*(x0-xi0)**3 + \
         (yi1/hi1 - zi1*hi1/6)*(x0-xi0) + \
         (yi0/hi1 - zi0*hi1/6)*(xi1-x0)
    return f0


arqxml = open("OUTPUT/INPUT.xml","r")
arqxmlr = arqxml.readlines()
inRecordingMode = False
Marray= []
kpoint= []
Kpoints= []
nowread = False
for line in arqxmlr:
#    xmldata = re.compile(r'<.*?>')
#    text_only = xmldata.sub('',line).strip()
    #match=re.search(r"k_point",line)
    if re.search(r"</starting_k_points",line):
        nowread = True
    if nowread:
        match_kpoints=re.search(r"<k_point .*>(.*)</k_point>",line)
        if match_kpoints:
            print(match_kpoints.group(1))
            for i in match_kpoints.group(1).split():        #print("EIGEN")
                kpoint.append(float(i))
            Kpoints.append(kpoint)
            kpoint= [] 
        if not inRecordingMode:
            if re.match(r"\s*<eigenvalues.*>", line):
                #print('detectou')
                inRecordingMode = True
                array= []
        else:
            if re.match(r"\s+</eigenvalues>", line):
            #    print("detectoufim")
                inRecordingMode = False
                Marray.append(array)
            else:
                for i in line.split():
                    print(i)
                    array.append(13.6056980659*float(i))
                    print(array)
arqxml.close()
print(Marray)
print(Kpoints)
kpointsarr=range(len(Kpoints))
#print(kpoint)                 
fig = plt.figure()
plt.axis([0, max(kpointsarr), -0.1, 5.2])
for i in range(len(Marray[0])):
    band=[]
    for j in range(len(Marray)):
        band.append(Marray[j][i])
##    bandinter = interp1d(kpointsarr, band, kind="cubic")
    kinterp = np.linspace(0,  max(kpointsarr), num=10*len(Kpoints), endpoint=True)
    bandinter= cubic_interp1d(kinterp, kpointsarr, band)
    plt.plot(kpointsarr, band,'--',lw=0.55,color='black')
    plt.plot(kinterp, bandinter,'-',lw=0.55,color='blue')

#plt.show()
fig.savefig('hse_bands.jpg', format='jpg', dpi=1000)
EOF

fi



cd PP  ## entra na pasta de posprocessamento ###

if command -v python3 &>/dev/null; then
    echo Python 3 is installed
else
    echo Python 3 is not installed
    exit
fi

PIPCOMMAND="pip3"
if [ "$SERVER" = UFPEL ] ; then
PIPCOMMAND="pip"
conda activate p37  ### ativar environment para usar python3
fi


### instalar dependencias
python3 -c "import numpy"
if [ "$?" = 1 ] ; then 
	$PIPCOMMAND install numpy --user
fi
python3 -c "import matplotlib"
if [ "$?" = 1 ] ; then 
	$PIPCOMMAND install matplotlib --user
fi
python3 -c "import math"
if [ "$?" = 1 ] ; then 
	$PIPCOMMAND install math --user
fi
python3 -c "import re"
if [ "$?" = 1 ] ; then 
	$PIPCOMMAND install re --user
fi
python3 -c "import cycler"
if [ "$?" = 1 ] ; then 
	$PIPCOMMAND install cycler --user
fi

cat > plot_band_geral.py << EOF
#### SCRIPT TO PLOT BAND STRUCTURE ######
#!/usr/bin/env python
# Modified from band.py, written by Levi Lentz for the Kolpak Group at MIT
# This is distributed under the MIT license
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.gridspec as gs
import sys, os, re

#DO NOT EDIT ANYTHING IN HERE################################################
#############################################################################
#############################################################################
#############################################################################
#This function extracts the high symmetry points from the output of bandx.out
def Symmetries(fstring):
  f = open(fstring,'r')
  x = np.zeros(0)
  for i in f:
    if "high-symmetry" in i:
      x = np.append(x,float(i.split()[-1]))
  f.close()
  return x
#############################################################################
# Split list into lists by particular value 
def SplitBandsSection(test_list):
    size = len(test_list) 
    idx_list = [idx + 1 for idx, val in
                enumerate(test_list) if val == "|"] 
    
    idx_list.insert(0,0)
    idx_list.append(size)
    res=[]
    for i in range(len(idx_list)-1):
        if i < (len(idx_list)-2):
            res.append(test_list[idx_list[i]:idx_list[i+1]-1])
        else: # last section
            res.append(test_list[idx_list[i]:idx_list[i+1]])
    return res
#############################################################################

# This function takes in the datafile, the fermi energy, the symmetry file, a subplot, and the label
# It then extracts the band data, and plots the bands, the fermi energy in red, and the high symmetry points
def bndplot(filename,datafile,fermi,symmetryfile,colorband,HSpts,labelbands,y1,y2,leg_x,leg_y):
    fig, subplots = plt.subplots(1,len(datafile),sharey=True,sharex=True, gridspec_kw={'wspace': 0.1}, figsize=(8, 3))
    for nplot in range(len(datafile)):
      if len(datafile)==1:
          subplot=subplots
      else:
          subplot=subplots[nplot]
      z = np.loadtxt(datafile[nplot]) #This loads the bandx.dat.gnu file
      x = np.unique(z[:,0]) #This is all the unique x-points
      bands = []
      bndl = len(z[z[:,0]==x[1]]) #This gives the number of bands in the calculation
      Fermi = float(fermi[nplot])
      axis = [min(x),max(x), y1,y2]
      print(axis)
      for i in range(0,bndl):
        bands.append(np.zeros([len(x),2])) #This is where we storre the bands
      for i in range(0,len(x)):
        sel = z[z[:,0] == x[i]]  #Here is the energies for a given x
        test = []
        for j in range(0,bndl): #This separates it out into a single band
          bands[j][i][0] = x[i]
          bands[j][i][1] = np.multiply(sel[j][1],1)
      if labelbands[nplot] == '' or labelbands[nplot] == None :
          togetlabel=0
      else:
          togetlabel=1
          subplot.legend(loc=(leg_x, leg_y))
          
      for i in bands: #Here we plots the bands
         if togetlabel:
            subplot.plot(i[:,0],i[:,1]-fermi[nplot],label=labelbands[nplot],lw=1,color=colorband[nplot])
            togetlabel=0
         else:
            subplot.plot(i[:,0],i[:,1]-fermi[nplot],lw=1,color=colorband[nplot])
  
      temp = Symmetries(symmetryfile[nplot])
      print(temp)
      subplot.set_xticks(temp)
      ind = 0
      for j in temp: #This is the high symmetry lines
        x1 = [j,j]
        x2 = [axis[2],axis[3]]
        subplot.plot(x1,x2,'--',lw=0.3,color='black',alpha=0.75)
        subplot.text(j-max(x)/100,axis[2]-0.08*(axis[3]-axis[2]), HSpts[ind])
        ind+=1
      if nplot == 0: 
          subplot.set_ylabel("Energy (eV)")
      #subplot.plot([min(x),max(x)],[Fermi,Fermi],'--',color='black')
      subplot.set_xticklabels([])
      subplot.set_ylim([axis[2],axis[3]])
      subplot.set_xlim([axis[0],axis[1]])
    #fig.tight_layout()
    fig.savefig(filename+".svg", format='svg', dpi=1000)  ## para salvar um arquivo 
#############################################################################  


    
def bndplot_sep(filename,datafile,fermi,symmetryfile,colorband,HSpts,labelbands,y1,y2,leg_x,leg_y):
    ## defines number of sections in band plot, and define where in kpath it divides
    n_sep=HSpts.count("|")
    nplot=0
    pos_sep=[i for i,d in enumerate(HSpts) if d=='|']
    temp = Symmetries(symmetryfile[nplot])
    j=0; sep_values=[]; temp_coordstosplit=[]
    for i in pos_sep:
        k=i-j ## position to split
        sep_values.append(temp[k])
        j=j+1  ## have to increment to account for another | in array
        temp_coordstosplit.append(k)
    
    ## splits the band structure points and temp in subarrays.
    HSpts_splitted=SplitBandsSection(HSpts)
    temp_coordstosplit.insert(0,0); temp_coordstosplit.append(len(temp))
    
    temp_splitted=[]
    print(range(len(temp_coordstosplit)-1))
    for i in range(len(temp_coordstosplit)-1):
        if i < (len(temp_coordstosplit)-2):
            temp_splitted.append(temp[temp_coordstosplit[i]:temp_coordstosplit[i+1]])
            print(temp_coordstosplit[i],temp_coordstosplit[i+1])
        else: # last section
            temp_splitted.append(temp[temp_coordstosplit[i]:temp_coordstosplit[i+1]])
    deltas=[]
    for section in range(n_sep+1):

   #### calculate ratios for plot from temp_splitted
      delta=abs(temp_splitted[section][0]-temp_splitted[section][-1])
      deltas.append(delta)
    
    ## here the ratios between the graphs are defined to be
    # adjusted for the length of each kpath in subplots declaration
    D=temp[-1]-temp[0]
    print("D",deltas)
    deltas=[i/D for i in deltas]
    print(deltas)
    
    ## declares fig and subplots already appropriatedly scaled.
    fig, subplots = plt.subplots(1,n_sep+1,sharey=True,squeeze=True, gridspec_kw={'wspace': 0.3,'width_ratios': deltas})

    z = np.loadtxt(datafile[nplot]) #This loads the bandx.dat.gnu file
    x = np.unique(z[:,0]) #This is all the unique x-points
    bands = []
    bndl = len(z[z[:,0]==x[1]]) #This gives the number of bands in the calculation
    Fermi = float(fermi[nplot])
    axis = [min(x),max(x), y1,y2]
    print(axis)
    for i in range(0,bndl):
      bands.append(np.zeros([len(x),2])) #This is where we storre the bands
    for i in range(0,len(x)):
      sel = z[z[:,0] == x[i]]  #Here is the energies for a given x
      test = []
      for j in range(0,bndl): #This separates it out into a single band
        bands[j][i][0] = x[i]
        bands[j][i][1] = np.multiply(sel[j][1],1)
    if labelbands[nplot] == '' or labelbands[nplot] == None :
        togetlabel=0
    else:
        togetlabel=1
        subplot.legend(loc=(leg_x, leg_y))
    
    indexes=[0] ## first index is 0
    for sep_value in sep_values:
        indexes.append(bands[0][:,0].tolist().index(sep_value)) ## find till where in bands to plot
    indexes.append(len(bands[0][:,0])-1) ## insert last index 
    
    for section in range(n_sep+1):
      subplot=subplots[section]
      subplot.set_xticklabels([])
      subplot.set_ylim([axis[2],axis[3]])
      
      subplots[section].set_xlim((temp_splitted[section][0],temp_splitted[section][-1]))
      for i in bands: #Here we plots the bands
          subplot.plot(i[indexes[section]:indexes[section+1],0],i[indexes[section]:indexes[section+1],1]-fermi[nplot],
                       lw=1,color=colorband[nplot])
      subplot.set_xticks(temp_splitted[section])
      ind = 0
      for j in temp_splitted[section]: #This is the high symmetry lines
        x1 = [j,j]
        x2 = [axis[2],axis[3]]
        subplot.plot(x1,x2,'--',lw=0.3,color='black',alpha=0.75)
        subplot.text(j-max(x)/100,axis[2]-0.08*(axis[3]-axis[2]), HSpts_splitted[section][ind])
        ind+=1
      if section == 0: 
          subplot.set_ylabel("Energy (eV)")
      #subplot.plot([min(x),max(x)],[Fermi,Fermi],'--',color='black')

    #fig.tight_layout()
    fig.savefig(filename+".svg", format='svg', dpi=1000)  ## para salvar um arquivo 
#############################################################################  
#############################################################################
#DO NOT EDIT ANYTHING IN HERE################################################



###### EDIT FROM HERE ON

### here have to insert all letters corresponding to brillouin zone path.
# Γ—C|C2—Y2—Γ—M2—D|D2—A—Γ|L2—Γ—V2 somethig like that

# Γ—X—S—Y—Γ—Z—U—R—T—Z
HSpts=['$\Gamma$','X','S','Y','$\Gamma$','Z','U','R','T','Z']

## define height of energy to plot
y1=-2
y2=+6
## where to put the legend
leg_x,leg_y=(0.7, 0.3)


if "|" not in HSpts:
    ## can add other datafile symfile, fermi, colors to plot another band side by side.
    filename="prefix_name"
    datafile=['./PP/prefix_bands.dat.gnu']  ## dat.gnu file contains all data
    symfile=['./PP/out.prefix_bands.bands'] ## out.bands in PP contains symmetry points
    fermi=[0] ## insert any value 
    colorbands=['blue']
    labelbands=[''] ## insert a label or put None ''
    bndplot(filename,datafile,fermi,symfile,colorbands,HSpts,labelbands, y1,y2,leg_x,leg_y)

else: #HSpts contains | , case of discontinuous band path.
    filename="prefix_SEP"
    datafile=['./PP/prefix_bands.dat.gnu']  ## dat.gnu file contains all data
    symfile=['./PP/out.prefix_bands.bands'] ## out.bands in PP contains symmetry points
    fermi=[0] ## insert any value 
    colorbands=['blue']
    labelbands=[''] ## insert a label or put None ''
    bndplot_sep(filename,datafile,fermi,symfile,colorbands,HSpts,labelbands, y1,y2,leg_x,leg_y)
EOF

cat > plot_PDOS_geralSP.py << EOF
### edite esse arquivo com o nivel de FERMI e o nome dos arquivos para plotar
### e assim criar um grafico customizado ao seu interesse.
import numpy as np
import matplotlib.pyplot as plt
import string
# import math
# import re
from matplotlib.ticker import MultipleLocator, FormatStrFormatter

from scipy.signal import convolve
from scipy.signal import gaussian

RANGE_VB=4.0 ## plotar quantos eV abaixo de Fermi
RANGE_CB=4.0  ## plotar quantos eV acima de Fermi


filename="prefix"  ## name to save figure in the end as filename.svg
nspin = 2   ## 2 means spin polarized # if spin polarized add label on setpdos
## directories where each projected DOS will be found for each graph.
alldir=['./PP/PDOS/' , # './PP/PDOS/'
         ] 

#FERMI=[-4.275, -2.036,-2.115]
FERMI=[ 0.0 ]#,-2.115]
# FERMI=[-2.042]
 # fermi energies for each system find in out.nscf or prefix.dos
listpdos_files1=['p.pdos_tot','sumpdos_p.Sb3p',
                 'sumpdos_p.Br2p','sumpdos_p.Sb2s' 
                 ]

listpdos_files2=['p.pdos_tot','sumpdos_p.Sb3p',
                 'sumpdos_p.Br2p','sumpdos_p.Sb2s' 
                 ]

listpdos_files3=['p.pdos_tot','sumpdos_p.Sb3p',
                 'sumpdos_p.Br2p','sumpdos_p.Sb2s' 
                 ]


## if 1 in second field the corresponding file will be plotted if 0 not plotted
## if 2 filled plot
setspdos1=[ ['Total',2,'blue','blue',0.3,'solid'],
                      ['Sb $\it{5p}$',1,'purple','purple',1,'solid'],
                      ['Br $\it{4p}$',1,'green','green',1,'solid'],
                      ['Sb $\it{5s}$',1,'blue','blue',1,'solid'],
          ]

setspdos2=[ ['Total',2,'blue','blue',0.3,'solid'],
                      ['Sb $\it{5p}$',1,'purple','purple',1,'solid'],
                      ['Br $\it{4p}$',1,'green','green',1,'solid'],
                      ['Sb $\it{5s}$',1,'blue','blue',1,'solid'],
          ]

setspdos3=[ ['Total',2,'blue','blue',0.3,'solid'],
                      ['Sb $\it{5p}$',1,'purple','purple',1,'solid'],
                      ['Br $\it{4p}$',1,'green','green',1,'solid'],
                      ['Sb $\it{5s}$',1,'blue','blue',1,'solid'],
          ]


plotsettings=[  setspdos1 #, setspdos2, setspdos3
              ]
# plotsettings=[setspdos4
#                ]

all_listpdos=[  listpdos_files1 #, listpdos_files2, listpdos_files3
              ]


allPDOSfiles=[] # array with all PDOS files read with numpy
energies=[]  # array with energy range for each system

PDOSlist_alldata=[]  # array with all PDOS data (only density of states) for each system
for j in range(len(alldir)):
    listpdos_files = all_listpdos[j] ## read listpdos_files1, listpdos_files2, and so on.
    energy=[] ## read energy array of the system
    PDOSfile=[] ## stores the PDOSfile being read
    PDOSlist_data=[]  ## stores the PDOS data of the file
    for i in range(len(listpdos_files)):
        print(alldir[j]+listpdos_files[i])  ## prints the file being read
        PDOSfile.append(np.genfromtxt(alldir[j]+listpdos_files[i])) ## reads the file
        if i==0:
            energy=PDOSfile[i][:,0]-FERMI[j] ## gets the energy
        tmpPDOS = PDOSfile[i][:,1]  ## gets the PDOS
        tmpPDOS=tmpPDOS[(energy>-RANGE_VB) & (energy<RANGE_CB)]  ## corrects to exclude values not to be plotted
        
        if nspin == 2:
            tmpPDOS2 = PDOSfile[i][:,2]  ## gets the PDOS
            tmpPDOS2=tmpPDOS2[(energy>-RANGE_VB) & (energy<RANGE_CB)]  ## corrects to exclude values not to be plotted
            PDOSlist_data.append([tmpPDOS,tmpPDOS2])    
        else:
            PDOSlist_data.append(tmpPDOS)
        
        # PDOSlist_data.append(PDOSfile[i][:,1])
        # PDOSlist_data[i]=PDOSlist_data[i][energy>-RANGE_VB]
    allPDOSfiles.append(PDOSfile)
    PDOSlist_alldata.append(PDOSlist_data)
    energy=energy[(energy>-RANGE_VB) & (energy<RANGE_CB)] ## corrects to exclude values not to be plotted

    energies.append(energy)
print(PDOSlist_alldata)
# import sys 
# sys.exit()

###smoothing function
nw= 256
std = 1
window = gaussian(nw, std, sym=True)
for j in range(len(alldir)):
  print(j)
  for i in range(len(listpdos_files)):
      print(i)
      if nspin == 2:
          PDOSlist_alldata[j][i][0] = convolve(PDOSlist_alldata[j][i][0], window, mode='same') /np.sum(window)
          PDOSlist_alldata[j][i][1] = convolve(PDOSlist_alldata[j][i][1], window, mode='same') /np.sum(window)
      else:
          PDOSlist_alldata[j][i] = convolve(PDOSlist_alldata[j][i], window, mode='same') /np.sum(window)
print('value',np.max(PDOSlist_alldata[0][0]))



### have to smooth before getting max value
heightscale=1.05 ### this will determine how much will be blank on top of the graph
height_plots= []
for j in range(len(alldir)):
    height_plots.append(np.max(PDOSlist_alldata[j][0])*heightscale)
#sys.exit()
print(height_plots)


### PLOTANDO O GRAFICO ###########################################
#fig, (ax1,ax2,ax3) = plt.subplots(3,1,sharey=True,sharex=True, gridspec_kw={'hspace': 0})
fig, axs = plt.subplots(len(alldir),1,sharey=True,sharex=True, gridspec_kw={'hspace': 0})
fig.set_figheight(4)
fig.set_figwidth(8)
plt.rcParams['font.size']=14

## para conseguir colocar labels comuns a todos subplots
fig.add_subplot(111, frameon=False)

# add a big axis, hide frame
plt.tick_params(labelcolor='none', top=False, bottom=False, left=False, right=False)
# hide tick and tick label of the big axis
plt.xlabel("Energy (eV)")
plt.ylabel("DOS")
########
### DEFININDO OS TICKS EM X
majorxLocator   = MultipleLocator(1)
majorxFormatter = FormatStrFormatter('%d')
minorxLocator   = MultipleLocator(0.5)
### DEFININDO OS TICKS EM Y
majoryLocator   = MultipleLocator(40)
majoryFormatter = FormatStrFormatter('%d')
minoryLocator   = MultipleLocator(20)

abclist=list(string.ascii_lowercase)  ###lowercase alphabet list
i=0
if nspin ==2 :
    setaxis=[-RANGE_VB, RANGE_CB, -np.max(height_plots), np.max(height_plots) ]
else :
    setaxis=[-RANGE_VB, RANGE_CB, 0, np.max(height_plots) ]
print(energies, PDOSlist_alldata )



# axs.plot(energies[0],PDOSlist_alldata[0][0] )
# axs.plot(energies[0],-PDOSlist_alldata[0][1] )

# import sys
# sys.exit()
for j in range(len(alldir)):
    if len(alldir) == 1:
        ax = axs
    else:
        ax = axs[j]
### https://matplotlib.org/devdocs/gallery/subplots_axes_and_figures/subplots_demo.html


    for i in range(len(listpdos_files)):
      if plotsettings[j][i][1] == 1 : ## only what defined to be plotted
          if nspin == 2:
              ax.plot(energies[j],PDOSlist_alldata[j][i][0],label=plotsettings[j][i][0],
                    color=plotsettings[j][i][2], lw=plotsettings[j][i][4],
                    ls=plotsettings[j][i][5] )
              ax.plot(energies[j],-PDOSlist_alldata[j][i][1],label=plotsettings[j][i][0],
                    color=plotsettings[j][i][3], lw=plotsettings[j][i][4],
                    ls=plotsettings[j][i][5] )
          else:
              ax.plot(energies[j],PDOSlist_alldata[j][i],label=plotsettings[j][i][0],
                    color=plotsettings[j][i][2], lw=plotsettings[j][i][3],
                    ls=plotsettings[j][i][4] )
      if plotsettings[j][i][1] == 2 : ## plots with filling
          if nspin == 2:
              ax.fill_between(energies[j],PDOSlist_alldata[j][i][0],y2=0,
                              color=plotsettings[j][i][2], 
                              alpha=plotsettings[j][i][4],linewidth=0 )
              ax.fill_between(energies[j],-PDOSlist_alldata[j][i][1],y2=0,
                              color=plotsettings[j][i][3], 
                              alpha=plotsettings[j][i][4],linewidth=0 )
          else:
              ax.fill_between(energies[j],PDOSlist_alldata[j][i],y2=0,
                        color=plotsettings[j][i][2],
                        alpha=plotsettings[j][i][3], linewidth=0)
    ax.axis(setaxis)
    # axx.text(-RANGE_VB+0.2, 0.9*np.max(height_plots), "("+abclist[i]+")", fontsize=15)
    i+=1
    ax.xaxis.set_major_locator(majorxLocator)
    ax.xaxis.set_major_formatter(majorxFormatter)
    ax.xaxis.set_minor_locator(minorxLocator)
    ax.yaxis.set_major_locator(majoryLocator)
    ax.yaxis.set_major_formatter(majoryFormatter)
    ax.yaxis.set_minor_locator(minoryLocator)
    #ax.set_yticklabels([])
    #ax.axvline(x=0, ymin=setaxis[2], ymax=setaxis[3], ls='--', color='black',alpha=0.5)
        ## if you want to show each legend the following lines can be useful.
        #axx.legend(loc='upper left')
        #axx.legend(bbox_to_anchor=(1, 1),loc='upper left')
      #   axx.set_yticks([])
   # plt.yticks([])
   
   ##### LEGEND POSITION
legendposition_tuple=(1, 1)

handles = []
labels = []
for j in range(len(alldir)):
    if len(alldir) == 1:
        ax = axs
    else:
        ax = axs[j]
### make a text label to identify each compound
    compounds=['','','',
                '$','$']

    ax.text(setaxis[1]-3,setaxis[3]-8, compounds[j],size=16)

    handle,label = ax.get_legend_handles_labels()
    
    if nspin!=2:
        handles.extend(x for x in handle if x not in handles)
        labels.extend(x for x in label if x not in labels)
    else:
        handles=handle
        labels=label
    # else:
    #     handles.extend(x for x in handle if x not in handles)
    #     labels.extend(x for x in label if x not in labels)
if len(alldir) == 1:
      ax = axs
      if nspin == 2:
          ax.legend(handles[::2],labels[::2],bbox_to_anchor=legendposition_tuple,labelspacing=0.3,
                  loc='upper left', frameon=False, prop={"size":16})
      else:
          ax.legend(handles,labels,bbox_to_anchor=legendposition_tuple,labelspacing=0.3,
                  loc='upper left', frameon=False, prop={"size":16})
      # 
else:
        ax = axs[0]
        if nspin == 2:
          ax.legend(handles[::2],labels[::2],bbox_to_anchor=legendposition_tuple,labelspacing=0.3,
                  loc='upper left', frameon=False, prop={"size":16})
        else:
          ax.legend(handles,labels,bbox_to_anchor=legendposition_tuple,labelspacing=0.3,
                  loc='upper left', frameon=False, prop={"size":16})
        # ax[0].legend()

        # handles+=handle
        # labels+=label
print(handles, labels)
# for j in range(len(alldir)):
#       if len(alldir) == 1:
#           ax = axs
#       else:
#           ax = axs[j]
#       ax.legend()


fig.set_size_inches(8.5, 5.5)
plt.tight_layout()
#plt.show()  ### only shows plot
fig.savefig(filename+'.svg', format='svg', dpi=1000)  ## to save a file.
fig.savefig(filename+'.png', format='png', dpi=1000)  ## to save a file.

## case you need graph with no axes.
# # Hide the right and top spines
# ax.spines['right'].set_visible(False)
# ax.spines['top'].set_visible(False)
# ax.spines['left'].set_visible(False)

# # Only show ticks on the left and bottom spines
# ax.yaxis.set_ticks_position('left')
# ax.xaxis.set_ticks_position('bottom')

# plt.ylabel("")
# ax.get_legend().remove()
# ax.axes.get_yaxis().set_visible(False)
#plt.show()  ### only shows plot
#fig.savefig(filename+'.svg', format='svg', dpi=1000)  ## to save a file.

EOF

cat > plot_PDOS_specified.py << EOF
### edite esse arquivo com o nivel de FERMI e o nome dos arquivos para plotar
### e assim criar um grafico customizado ao seu interesse.
import numpy as np
import matplotlib.pyplot as plt
import string
# import math
# import re
from matplotlib.ticker import MultipleLocator, FormatStrFormatter

from scipy.signal import convolve
from scipy.signal import gaussian
import glob, os

RANGE_VB=3.0 ## plotar quantos eV abaixo de Fermi
RANGE_CB=3.0  ## plotar quantos eV acima de Fermi

PREFIX="CSBrNC38pbe"
filename="SpecifiedPDOS_"+PREFIX  ## name to save figure in the end as filename.svg


nspin = 2   ## 2 means spin polarized # if spin polarized add label on setpdos
sumstates=1 ## if 1 it will sum all states in range except pdos_tot , else each 
            ## will be plotted individually

## directories where each projected DOS will be found for each graph.
PDOSdir='./NC38hs_final/PP/PDOS/' # './PP/PDOS/'
        
### set fermi value
#FERMI=[-4.275, -2.036,-2.115]
FERMI=-3.738 #,-2.115]
# FERMI=[-2.042]
 # fermi energies for each system find in out.nscf or prefix.dos
os.chdir(PDOSdir)
fileslist=[]
for index,file in enumerate(glob.glob(PREFIX+".pdos*",recursive=True)):
    print(index,file)
    fileslist.append(file)


pdostot_ind=fileslist.index(PREFIX+".pdos_tot")


### EXECUTAR COM ESSAS LINHAS ANTES PARA PEGAR SO A NUMERACAO DOS ATOMOS PARA DEPOIS
### INCLUIR NO WHICH PLOT
#print(fileslist)
# import sys
# sys.exit()

whichToPlot=list(range(34,49))+list(range(51,54))+[pdostot_ind]  ## Sb  ## pdostot_ind always in the end
#whichToPlot=list(range(0,34))+list(range(49,51))+list(range(95,97))+[pdostot_ind]  ## Br  ## pdostot_ind always in the end

listpdos_files=[ fileslist[i] for i in whichToPlot ]
print(listpdos_files)



all_listpdos=[  listpdos_files #, listpdos_files2, listpdos_files3
              ]
allPDOSfiles=[] # array with all PDOS files read with numpy
energies=[]  # array with energy range for each system

PDOSlist_alldata=[]  # array with all PDOS data (only density of states) for each system
energy=[] ## read energy array of the system
PDOSfile=[] ## stores the PDOSfile being read
PDOSlist_data=[]  ## stores the PDOS data of the file
for i in range(len(listpdos_files)):
        # print(listpdos_files[i])  ## prints the file being read
        PDOSfile.append(np.genfromtxt(listpdos_files[i])) ## reads the file
        if i==0:
            energy=PDOSfile[i][:,0]-FERMI ## gets the energy
        tmpPDOS = PDOSfile[i][:,1]  ## gets the PDOS
        tmpPDOS=tmpPDOS[(energy>-RANGE_VB) & (energy<RANGE_CB)]  ## corrects to exclude values not to be plotted
        
        if nspin == 2:
            tmpPDOS2 = PDOSfile[i][:,2]  ## gets the PDOS
            tmpPDOS2=tmpPDOS2[(energy>-RANGE_VB) & (energy<RANGE_CB)]  ## corrects to exclude values not to be plotted
            PDOSlist_data.append([tmpPDOS,tmpPDOS2])    
        else:
            PDOSlist_data.append(tmpPDOS)
        
        # PDOSlist_data.append(PDOSfile[i][:,1])
        # PDOSlist_data[i]=PDOSlist_data[i][energy>-RANGE_VB]
allPDOSfiles.append(PDOSfile)
PDOSlist_alldata.append(PDOSlist_data)
energy=energy[(energy>-RANGE_VB) & (energy<RANGE_CB)] ## corrects to exclude values not to be plotted

energies.append(energy)
# print(PDOSlist_alldata)
# import sys 
# sys.exit()

###smoothing function
nw= 256
std = 40
window = gaussian(nw, std, sym=True)

for i in range(len(listpdos_files)):
    # print(i)
    if nspin == 2:
        PDOSlist_alldata[0][i][0] = convolve(PDOSlist_alldata[0][i][0], window, mode='same') /np.sum(window)
        PDOSlist_alldata[0][i][1] = convolve(PDOSlist_alldata[0][i][1], window, mode='same') /np.sum(window)
    else:
        PDOSlist_alldata[0][i] = convolve(PDOSlist_alldata[0][i], window, mode='same') /np.sum(window)
# print('value',np.max(PDOSlist_alldata[0][0]))



### have to smooth before getting max value
heightscale=1.05 ### this will determine how much will be blank on top of the graph
height_plots= []

height_plots.append(np.max(PDOSlist_alldata[0][-1])*heightscale)
#sys.exit()
# print(height_plots)


### PLOTANDO O GRAFICO ###########################################
#fig, (ax1,ax2,ax3) = plt.subplots(3,1,sharey=True,sharex=True, gridspec_kw={'hspace': 0})
fig, axs = plt.subplots(1,1,sharey=True,sharex=True, gridspec_kw={'hspace': 0})
fig.set_figheight(4)
fig.set_figwidth(8)
plt.rcParams['font.size']=14

## para conseguir colocar labels comuns a todos subplots
fig.add_subplot(111, frameon=False)

# add a big axis, hide frame
plt.tick_params(labelcolor='none', top=False, bottom=False, left=False, right=False)
# hide tick and tick label of the big axis
plt.xlabel("Energy (eV)")
plt.ylabel("DOS")
########
### DEFININDO OS TICKS EM X
majorxLocator   = MultipleLocator(1)
majorxFormatter = FormatStrFormatter('%d')
minorxLocator   = MultipleLocator(0.5)
### DEFININDO OS TICKS EM Y
majoryLocator   = MultipleLocator(40)
majoryFormatter = FormatStrFormatter('%d')
minoryLocator   = MultipleLocator(20)

abclist=list(string.ascii_lowercase)  ###lowercase alphabet list
i=0
if nspin ==2 :
    setaxis=[-RANGE_VB, RANGE_CB, -np.max(height_plots), np.max(height_plots) ]
else :
    setaxis=[-RANGE_VB, RANGE_CB, 0, np.max(height_plots) ]
# print(energies, PDOSlist_alldata )



# axs.plot(energies[0],PDOSlist_alldata[0][0] )
# axs.plot(energies[0],-PDOSlist_alldata[0][1] )



### https://matplotlib.org/devdocs/gallery/subplots_axes_and_figures/subplots_demo.html

ax = axs
if nspin==2:
    PDOSsumUP=np.zeros(len(PDOSlist_alldata[0][0][0]))
    PDOSsumDOWN=np.zeros(len(PDOSlist_alldata[0][0][0]))
else :
    PDOSsum=np.zeros(PDOSlist_alldata[0][i])
for i in range(len(listpdos_files)-1):  ## if sum states true will sum data in this part, if sumstates false, will plot individually here
          if sumstates == 1:
              PDOSsumUP+=np.array(PDOSlist_alldata[0][i][0])
              PDOSsumDOWN+=np.array(PDOSlist_alldata[0][i][1])
          else:
              if nspin == 2:
                  ax.plot(energies[0],PDOSlist_alldata[0][i][0],label=listpdos_files[i].split(".")[1])
                  ax.plot(energies[0],-PDOSlist_alldata[0][i][1],label=listpdos_files[i].split(".")[1])
              else:
                  ax.plot(energies[0],PDOSlist_alldata[0][i],label=listpdos_files[i].split(".")[1])

if sumstates == 1:
      ax.plot(energies[0],PDOSsumUP,label="UP SUM")
      ax.plot(energies[0],-PDOSsumDOWN,label="DOWN SUM")
## plot pdos_tot

if nspin == 2:
    ax.fill_between(energies[0],PDOSlist_alldata[0][-1][0],y2=0,
                    color="blue", 
                    alpha=0.3,linewidth=0 )
    ax.fill_between(energies[0],-PDOSlist_alldata[0][-1][1],y2=0,
                    color="blue", 
                    alpha=0.3,linewidth=0 ) 
else:
    ax.fill_between(energies[0],PDOSlist_alldata[0][-1],y2=0,
                    color="blue", 
                    alpha=0.3,linewidth=0 ) 

      
ax.axis(setaxis)
# axx.text(-RANGE_VB+0.2, 0.9*np.max(height_plots), "("+abclist[i]+")", fontsize=15)
i+=1
ax.xaxis.set_major_locator(majorxLocator)
ax.xaxis.set_major_formatter(majorxFormatter)
ax.xaxis.set_minor_locator(minorxLocator)
ax.yaxis.set_major_locator(majoryLocator)
ax.yaxis.set_major_formatter(majoryFormatter)
ax.yaxis.set_minor_locator(minoryLocator)
    #ax.set_yticklabels([])
    #ax.axvline(x=0, ymin=setaxis[2], ymax=setaxis[3], ls='--', color='black',alpha=0.5)
        ## if you want to show each legend the following lines can be useful.
        #axx.legend(loc='upper left')
        #axx.legend(bbox_to_anchor=(1, 1),loc='upper left')
      #   axx.set_yticks([])
   # plt.yticks([])
   
   ##### LEGEND POSITION
legendposition_tuple=(0.5, 1)

handles = []
labels = []

### make a text label to identify each compound
compounds=['','','',
            '$','$']

ax.text(setaxis[1]-3,setaxis[3]-8, compounds[0],size=16)

handle,label = ax.get_legend_handles_labels()

if nspin!=2:
    handles.extend(x for x in handle if x not in handles)
    labels.extend(x for x in label if x not in labels)
else:
    handles=handle
    labels=label
    # else:
    #     handles.extend(x for x in handle if x not in handles)
    #     labels.extend(x for x in label if x not in labels)

# if nspin == 2:
#     ax.legend(handles[::2],labels[::2],bbox_to_anchor=legendposition_tuple,labelspacing=0.3,
#             loc='upper left', frameon=False, prop={"size":12})
# else:
# ax.legend(handles,labels,bbox_to_anchor=legendposition_tuple,labelspacing=0.3,
#         loc='upper left', frameon=False, prop={"size":12})
      # 
        # labels+=label
# print(handles, labels)
# for j in range(len(alldir)):
#       if len(alldir) == 1:
#           ax = axs
#       else:
#           ax = axs[j]
#       ax.legend()


fig.set_size_inches(8.5, 5.5)
plt.tight_layout()
#plt.show()  ### only shows plot
fig.savefig(filename+'.svg', format='svg', dpi=1000)  ## to save a file.
fig.savefig(filename+'.png', format='png', dpi=1000)  ## to save a file.


EOF


cat > band.py << EOF
#### PLOT DA ESTRUTURA DE BANDAS ######
#!/usr/bin/env python
# Modified from band.py, written by Levi Lentz for the Kolpak Group at MIT
# This is distributed under the MIT license
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.gridspec as gs
import sys, os, re

PREFIX=str(sys.argv[1])
## EXTRAIR A ENERGIA DE FERMI DO DOS
if not os.path.isfile(PREFIX+'.dos'):
    print("A DOS file couldn't be found to extract fermi energy.")
    exit() 
with open(PREFIX+'.dos') as f:
    first_line = f.readline()
result = re.findall(r"Fermi *[^\w ] *(.*) eV", first_line, re.IGNORECASE | re.MULTILINE)
fermi=round(float(result[0]),3)
with open('../out.'+PREFIX+'.nscf') as f:
  for line in f :
    if re.search("highest", line):
      re_fermi = line.split()
      fermi=round(float(re_fermi[6]),3)
    if re.search("Fermi energy", line):
      re_fermi = line.split()
      fermi=round(float(re_fermi[4]),3)
print('fermi: ',fermi)


#This function extracts the high symmetry points from the output of bandx.out
def Symmetries(fstring):
  f = open(fstring,'r')
  x = np.zeros(0)
  for i in f:
    if "high-symmetry" in i:
      x = np.append(x,float(i.split()[-1]))
  f.close()
  return x
# This function takes in the datafile, the fermi energy, the symmetry file, a subplot, and the label
# It then extracts the band data, and plots the bands, the fermi energy in red, and the high symmetry points
def bndplot(datafile,fermi,symmetryfile,subplot,label):
  z = np.loadtxt(datafile) #This loads the bandx.dat.gnu file
  x = np.unique(z[:,0]) #This is all the unique x-points
  bands = []
  bndl = len(z[z[:,0]==x[1]]) #This gives the number of bands in the calculation
  Fermi = float(fermi)
  axis = [min(x),max(x),Fermi - 8, Fermi + 8]
  for i in range(0,bndl):
    bands.append(np.zeros([len(x),2])) #This is where we storre the bands
  for i in range(0,len(x)):
    sel = z[z[:,0] == x[i]]  #Here is the energies for a given x
    test = []
    for j in range(0,bndl): #This separates it out into a single band
      bands[j][i][0] = x[i]
      bands[j][i][1] = np.multiply(sel[j][1],1)
  for i in bands: #Here we plots the bands
    subplot.plot(i[:,0],i[:,1],color="black")
  temp = Symmetries(symmetryfile)
  for j in temp: #This is the high symmetry lines
    x1 = [j,j]
    x2 = [axis[2],axis[3]]
    subplot.plot(x1,x2,'--',lw=0.55,color='black',alpha=0.75)
  subplot.plot([min(x),max(x)],[Fermi,Fermi],color='red',)
  subplot.set_xticklabels([])
  subplot.set_ylim([axis[2],axis[3]])
  subplot.set_xlim([axis[0],axis[1]])
  subplot.text((axis[1]-axis[0])/2.0,axis[3]+0.2,label,va='center',ha='center',fontsize=20)
  fig = plt.gcf()
  plt.show()
  fig.savefig(str(label)+'_bands.eps', format='eps', dpi=1000)


datafile='band_'+PREFIX+'.dat.gnu'
symfile='out.'+PREFIX+'.bands'
plot=plt.axes()
bndplot(datafile,fermi,symfile,plot,PREFIX)
print('Band structure plotted in file '+PREFIX+'_bands.eps .')
EOF

python3 band.py $INPUT

cat > baderPP.py << EOF
import re
import sys
import glob
import numpy as np

### funcao para fazer um grep em arquivos
def grep(filename,regex):
      for file in glob.iglob(filename):
         for line in open(file, 'r'):
            if re.search(regex, line):
               return line

PREFIX=str(sys.argv[1])

### pegar nat e ntyp do input do QE
subject=grep('../'+PREFIX+'.scf.in','nat')
match = re.search("nat\s{0,}.\s{0,}(\d{1,})", subject)  ## . para ignorar o = entre paranteses o que quer dar match, \d{1,} significa uma ou mais ocorrencias de digito, igualmente \s{0,} vai considerar nenhum ou algum espaco
if match:
    nat = match.group(1)
else:
    print('Error: could not find number of atoms in file')
#print(nat)

subject=grep('../'+PREFIX+'.scf.in','ntyp')
match = re.search("ntyp\s{0,}.\s{0,}(\d{1,})", subject)  ## . para ignorar o = entre paranteses o que quer dar match, \d{1,} significa uma ou mais ocorrencias de digito, igualmente \s{0,} vai considerar nenhum ou algum espaco
if match:
    ntyp = match.group(1)
else:
    print('Error: could not find ntyp in file')
#print(ntyp)



### ler arquivo de carga do posprocessamento
filecharge=PREFIX+'.charge'
with open(filecharge) as fhand:
    lines = [line.rstrip("\n") for line in fhand]
    i=-1   ## i sera a linha da primeira ocorrencia da identificacao de carga
    for line in lines:
#      print(line)
      i=i+1
## iniciando com espacos depois digitos espacos letras espacos digitos, para pegar linhas de carga '    1   XX   20'
      if re.match(r"^\s+\d+\s+[a-zA-Z]+\s+\d+", line): 
         print(i)
         break
      
chargeatoms=lines[i:i+int(ntyp)]
chargeatomslist=[ line.split() for line in chargeatoms] ## dados para elementos
chargedata=lines[i+int(ntyp):i+int(ntyp)+int(nat)] ## so os dados de carga

### ler arquivo da analise de bader
filebader='../'+PREFIX+'-ACF.dat'
with open(filebader) as fhand:
    lines = [line.rstrip("\n") for line in fhand]
baderdata=lines[2:2+int(nat)]
#transforma arquivos em nparrays
bader = np.genfromtxt(baderdata)
charge = np.genfromtxt(chargedata)
chargeatoms = np.genfromtxt(chargeatoms)
chargeatoms = chargeatoms[:,2] ## somente as cargas dos atomos

#for linha in bader verifica linha in chargedata, pega  da charge data, encontra o valor correspondente da  in chargeatoms , subtrai esse valor da  do bader
atomlist=[] ### lista dos elementos em ordem
for i in range(int(nat)):  ##  varre de 0 a 12
    idatom=int(charge[i,4])-1 ## pega o id do atomo no arquivo de carga ##pq posicao 0 e 1 aqui
    chgatom=chargeatoms[idatom] ## usa esse id para pegar a carga nominal do atomo
    bader[i,4]=bader[i,4]-chgatom  ## pega a carga do atomo por bader e subtrai a carga nominal
    bader[0,0]=np.array(bader[0,0].astype(str))
    atomslist=atomlist.append(chargeatomslist[idatom][1])

dt=np.dtype([('col0','U4'),('col1',float), ('col2',float),('col3',float), ('col4',float),('col5',float), ('col6',float)])
baderfinal = np.empty((int(nat),), dtype=dt)
baderfinal['col0'] = atomlist
baderfinal['col1'] = bader[:,1]
baderfinal['col2'] = bader[:,2]
baderfinal['col3'] = bader[:,3]
baderfinal['col4'] = bader[:,4]
baderfinal['col5'] = bader[:,5]
baderfinal['col6'] = bader[:,6]
#print(baderfinal)

np.savetxt('BaderChgAnalysis_'+PREFIX+'.out', baderfinal, delimiter=' ', header="Element, x, y, z, ChargeTransfered, MinDist, AtomVol", fmt="%3s %9f %9f %9f %9f %9f %9f")
EOF
python3 baderPP.py $INPUT

cat > getGapSP.py << "EOF"
# import re
import glob
import numpy as np
# import matplotlib.pyplot as plt
# import sys

nspin=False
RANGE_VB=3
RANGE_CB=3
CUTOFF_DOS=1 ## value above is considered 1
fermi_idx_tol=500  ## difference in index from fermi index to consider gap close to fermi level




datatxt=""
for file in glob.glob("**/*.dos",recursive=True):
    if len(file.split('\\')[-1].split('.')) > 2:
        continue  ## case of out.*.dos files skipped
    name=str(file)
    print("DOS FILE GIVEN:", name)
    datatxt=datatxt+"DOS FILE GIVEN: "+name+"\n"
    datatxt=datatxt+"----------------------------------------------------------- \n"
    with open(file) as f:
        line0=f.readlines()[0].split()[-2]  ## to get efermi on top of .dos file
        fermi=float(line0)
    data = np.genfromtxt(file)
    #print(data[data[:,0]==fermi][0][1])
    print("fermi",fermi)


    ## test spin polarized
    if len(data[0,:]) > 3:
        nspin=True
        print("SPIN POLARIZED CONSIDERED!")

    ## only data in specified range
    data_in_range=data[data[:,0]>(fermi-RANGE_VB)]
    data_in_range=data_in_range[data_in_range[:,0]<(fermi+RANGE_CB)]
    energy=data_in_range[:,0]
    fermiidx=np.argwhere(energy==fermi)[0][0]
    if nspin:
        DOSup=np.where(data_in_range[:,1] > CUTOFF_DOS, 1, 0)
        DOSdown=np.where(data_in_range[:,2] > CUTOFF_DOS, 1, 0)
        DOSint=np.where(np.diff(data_in_range[:,3]) > 0.1, 1, 0)
    else:
        DOS=np.where(data_in_range[:,1] > CUTOFF_DOS, 1, 0)
        DOSint=np.where(np.diff(data_in_range[:,2]) > 0.1, 1, 0)
        
        
        
        ### detect all gaps in DOS, those closer to efermi are indicated.
    if nspin:
        counting=False
        idx0=0
        idx1=0
        for idx, entry in enumerate(DOSup):
            if entry == 0 and counting==False:
                counting=True
                idx0=idx
                difftofermi=idx0-fermiidx 
            if entry == 1 and counting==True:
                counting=False
                idx1=idx
                gap=energy[idx1]-energy[idx0]
                if gap > 0.1:
                    print("gap-SpinUP:",energy[idx1]-energy[idx0])
                    datatxt=datatxt+"gap-SpinUP: "+str(energy[idx1]-energy[idx0])
                    if abs(difftofermi) < fermi_idx_tol:
                        print("Probably real gap, close to Efermi")
                        datatxt=datatxt+"  Probably real gap, close to Efermi \n"
                    else:
                        datatxt=datatxt+"\n"

                        
        counting=False
        idx0=0
        idx1=0
        for idx, entry in enumerate(DOSdown):
            if entry == 0 and counting==False:
                counting=True
                idx0=idx
                difftofermi=idx0-fermiidx 
            if entry == 1 and counting==True:
                counting=False
                idx1=idx
                gap=energy[idx1]-energy[idx0]
                if gap > 0.1:
                    print("gap-SpinDOWN:",energy[idx1]-energy[idx0])
                    datatxt=datatxt+"gap-SpinDOWN: "+str(energy[idx1]-energy[idx0])
                    if abs(difftofermi) < fermi_idx_tol:
                        print("Probably real gap, close to Efermi")
                        datatxt=datatxt+"  Probably real gap, close to Efermi \n"
                    else:
                        datatxt=datatxt+"\n"                 
    
        counting=False
        idx0=0
        idx1=0
        for idx, entry in enumerate(DOSint):
            if entry == 0 and counting==False:
                counting=True
                idx0=idx
                difftofermi=idx0-fermiidx 
            if entry == 1 and counting==True:
                counting=False
                idx1=idx
                gap=energy[idx1]-energy[idx0]
                if gap > 0.1:
                    print("gap-anySPIN:",energy[idx1]-energy[idx0])
                    datatxt=datatxt+"gap-anySPIN: "+str(energy[idx1]-energy[idx0])
                    if abs(difftofermi) < fermi_idx_tol:
                        print("Probably real gap, close to Efermi")
                        datatxt=datatxt+"  Probably real gap, close to Efermi \n"
                    else:
                        datatxt=datatxt+"\n"

    else: ## no nspin
        counting=False
        idx0=0
        idx1=0
        for idx, entry in enumerate(DOS):
            if entry == 0 and counting==False:
                counting=True
                idx0=idx
                difftofermi=idx0-fermiidx 
            if entry == 1 and counting==True:
                counting=False
                idx1=idx
                gap=energy[idx1]-energy[idx0]
                if gap > 0.1:
                    print("gap:",energy[idx1]-energy[idx0])
                    datatxt=datatxt+"gap: "+str(energy[idx1]-energy[idx0])
                    if abs(difftofermi) < fermi_idx_tol:
                        print("Probably real gap, close to Efermi")
                        datatxt=datatxt+"  Probably real gap, close to Efermi \n"
                    else:
                        datatxt=datatxt+"\n"
    # plt.plot(data_in_range[:,0], DOSdown)
    datatxt=datatxt+"----------------------------------------------------------- \n"
with open("gaps.txt", "w") as text_file:
        text_file.write(datatxt)
EOF
python3 getGapSP.py

cat > baderaverage_bonds.py << EOF
   import numpy as np
import itertools
filename="BaderChgAnalysis_PREFIXO.out"
fileout="PREFIXO_baderbonds.out"
baderdata = np.loadtxt(filename,dtype={'names': ['element', 'x', 'y','z','charge'],
                     'formats': ['U10', 'f4', 'f4', 'f4','f8']},skiprows=1)
written_data=""
print(baderdata)
written_data=written_data+str(baderdata)+"\n"

baderdata=[list(baderdata[i]) for i in range(len(baderdata))] ## transform list makes easier to edit

## get list of elements
elements=[]
for row in baderdata:
    if row[0] not in elements:
        elements.append(row[0]) # if row[0] not in elements


## calculate average charge of each element
avgcharge=[]
for element in elements:
    count=0
    charge=0
    for row in baderdata:
        if element == row[0]:
            count+=1 ##increment number of the element
            charge+=row[4]
    avgcharge.append(charge/float(count))
print('------------------------------------------------------- \n')
print('------------------------------------------------------- \n')
written_data=written_data+'------------------------------------------------------- \n'+'------------------------------------------------------- \n'

print('Elements: ',elements)
print('Average charge of elements: ',avgcharge)   
written_data=written_data+'Elements: '+str(elements)+"\n"+'Average charge of elements: '+ \
             str(avgcharge)+"\n"

print('------------------------------------------------------- \n')
print('------------------------------------------------------- \n')
written_data=written_data+'------------------------------------------------------- \n'+'------------------------------------------------------- \n'


## labelling by element
labelelements=np.zeros(len(elements))
for row in baderdata:
    indexelement=elements.index(row[0])
    labelelements[indexelement]+=1 ## increase label of the element
    row.append(elements[indexelement]+str(int(labelelements[indexelement])))


## gets distance between different atoms within given cutoff
cutoff_bond=5  ## in angstrom
print('-------------CUTOFF FOR BOND LENGTH :  '+str(cutoff_bond)+'  angstrom ----------------------- \n')
written_data=written_data+'-------------CUTOFF FOR BOND LENGTH :  '+str(cutoff_bond)+'  angstrom ----------------------- \n'

distbond_table=[]
numberofbonds=0
for row in baderdata:
    for row2 in baderdata:
       if row2 != row:
             distxyz=np.array([(row2[i]-row[i])/1.88973 for i in range(1,4)])
             distbond = np.linalg.norm(distxyz)  ## get modulus, distance between atoms
             # print(distxyz,row[0],row2[0],distbond )
             
             if distbond < cutoff_bond:
                 distbond_table.append([row[0],row2[0],distbond,row[4],row2[4]])
                 print(str(row[5])+"-"+str(row2[5])+": "+str(distbond)+" ang" +" Charges: "+
                       str(row[4])+")-("+str(row2[4]))
                 written_data=written_data+str(row[5])+"-"+str(row2[5])+": "+str(distbond)+" ang" +" Charges: "+ \
                       str(row[4])+")-("+str(row2[4])+"\n"
                 numberofbonds+=1
    #         labelelements2[indexelement]+=1 ## increase label of the element
# print("DISTBONDTABLE",distbond_table)
possible_element_bonds=[list(comb) for comb in itertools.combinations(elements,2)]

avg_bond_length=np.zeros(len(possible_element_bonds))
bond_lengths = [[] for _ in range(len(possible_element_bonds))] ## list of lists with each bond
counter_bond=np.zeros(len(possible_element_bonds))
for bond in distbond_table:
    for index,typebond in enumerate(possible_element_bonds):
        if (typebond[0] == bond[0] and typebond[1] == bond[1]) or (typebond[1] == bond[0] and typebond[0] == bond[1]):
            avg_bond_length[index]+=bond[2]
           # if bond[2] not in bond_lengths[index]: ## no duplicates
            bond_lengths[index].append(bond[2])
            counter_bond[index]+=1
std_devs=[ np.std(bond_lengths[i]) for i in range(len(bond_lengths)) ]
variances=[ np.var(bond_lengths[i]) for i in range(len(bond_lengths)) ]
avs=[ np.average(bond_lengths[i]) for i in range(len(bond_lengths)) ]

# print(std_devs)
# print(variances)
# print(avs)
## how to ignore zeros in division
avg_bond_length = np.divide(avg_bond_length, counter_bond, out=np.zeros_like(avg_bond_length), where=counter_bond!=0)
# print(possible_element_bonds)
# print(avg_bond_length)
print('------------------------------------------------------- \n')
print('------------------------------------------------------- \n')
written_data=written_data+'------------------------------------------------------- \n'+'------------------------------------------------------- \n'

print("Average bond lengths, if 0 the atomic distance is larger than the cutoff to be considered a bond:")
[ print(possible_element_bonds[i][0]+"-"+possible_element_bonds[i][1]+":\n avg:"+str(avg_bond_length[i])+", std:"+ \
    str(std_devs[i])+", variance: "+str(variances[i])+" \n")  for i in range(len(possible_element_bonds)) ]
written_data=written_data+"Average bond lengths, if 0 the atomic distance is larger than the cutoff to be considered a bond: \n"
for i in range(len(possible_element_bonds)):
    written_data=written_data+possible_element_bonds[i][0]+"-"+possible_element_bonds[i][1]+": \n avg:"+str(avg_bond_length[i])+", std:"+ \
    str(std_devs[i])+", variance: "+str(variances[i])+" \n"
# print(written_data)
written_data=written_data+'------------------------------------------------------- \n'+'------------------------------------------------------- \n'
print('------------------------------------------------------- \n')
print('------------------------------------------------------- \n')

with open(fileout,"w") as f:
    f.write(written_data) 
EOF
python3 baderaverage_bonds.py $INPUT

################################################

cd PDOS
cat > sumpdos.py << 'EOF'

#! /usr/bin/python
#### acho que nao custa colocar o calculo de gap aqui tambem
import sys
import os
import fnmatch, re
import linecache
import matplotlib
import matplotlib.pyplot as plt
import glob
import numpy as np
from cycler import cycler

### funcao para fazer um grep em arquivos
def grep(filename,regex):
      for file in glob.iglob(filename):
         for line in open(file, 'r'):
            if re.search(regex, line):
               return line

PREFIX=str(sys.argv[1])

# Some default variables
fermi=0
graphtitle=""
min_x,max_x=-2,7
min_y,max_y="",""
wfcnumber='X'
wfc='X'
showgraph=0
nspin=1



if len(sys.argv)>1:
 for i in sys.argv:
  if i.startswith('-'):
   option=i.split('-')[1]
   if option=="f":
     fermi= sys.argv[sys.argv.index('-f')+1]
   if option=="ele":
    element= str(sys.argv[sys.argv.index('-ele')+1])
   if option=="wfc":
    wfc= str(sys.argv[sys.argv.index('-wfc')+1])
   if option=="wfcnumber":
    wfcnumber= str(sys.argv[sys.argv.index('-wfcnumber')+1])
   if option=="t":
    graphtitle= sys.argv[sys.argv.index('-t')+1]
   if option=="show":
    showgraph=1 
   if option=="xr":
    min_x,max_x= float(sys.argv[sys.argv.index('-xr')+1]),float(sys.argv[sys.argv.index('-xr')+2]) 
   if option=="yr":
    min_y,max_y= float(sys.argv[sys.argv.index('-yr')+1]),float(sys.argv[sys.argv.index('-yr')+2]) 
   if option=="h":
    print('''
    -f specify fermi energy in eV
    -ele Element for summing the DOSes. "X" for all    
    -wfc wavefunction for summing the DOSes. Example: s, p, d, f. "X" for all.
    -wfcnumber if you have distinct orbitals with same angular 
    quantum number, s, p, d, f. Define which one you want specifying the wfc number.
    -show Show the DOS in a graphical interface.
    -t set title in the head of the graph
    -xr set min and max x value for the axes in the graph
    -yr set min and max y value for the axes in the graph
    -h print this help
       Example: sum_states.py --s sys.pdos_atm#4\(Fe2\)_wfc#2\(d\) -t "Wustite LDA+U single Fe" -xr -9 4 
   ''')
    sys.exit()


### pegar nspin do input do QE
subject=grep('../../'+PREFIX+'.scf.in','nspin')
#print('subject:', subject)
#print(subject.strip().startswith('!'))
if subject != None and not subject.strip().startswith('!') :
    match = re.search("nspin\s{0,}.\s{0,}(\d{1,})", subject)  ## . para ignorar o = entre paranteses o que quer dar match, \d{1,} significa uma ou mais ocorrencias de digito, igualmente \s{0,} vai considerar nenhum ou algum espaco
    if match:
        nspin = int(match.group(1))
    else:
        print('Error: could not find npin in file. Using nspin=1.')
else:
    print('Error: could not find npin in file. Using nspin=1.')



datapdos= [ ]
dataelem= [ ]
for file in glob.glob(PREFIX+'.pdos_atm*'):
    print(file)
    re_atmnumber = re.findall(PREFIX+".pdos_atm#([0-9]{1,}).{1,}", file)
    print(re_atmnumber)
    re_atm = re.findall(PREFIX+".pdos_atm#[0-9]{1,}\(([a-zA-Z]{1,})\).{1,}", file)
    print(re_atm)
    re_wfcnumber = re.findall(PREFIX+".pdos_atm#[0-9]{1,}\([a-zA-Z]{1,}\)_wfc#([0-9])\([a-z]\)", file)
    print(re_wfcnumber)
    re_wfc = re.findall(PREFIX+".pdos_atm#[0-9]{1,}\([a-zA-Z]{1,}\)_wfc#[0-9]\(([a-z])\)", file)
    print(re_wfc)
    datapdos.append([ re_atm[0], re_wfcnumber[0], re_wfc[0]])
    dataelem.append([ re_atm[0] ])
datapdos=np.array(datapdos)  ### conjunto de dados de projecao
datapdos=np.unique(datapdos,axis=0)   ### dados de projecao sem repeticao
print(datapdos)
dataelem=np.array(dataelem)  ### conjunto de dados de projecao
dataelem=np.unique(dataelem,axis=0)   ### dados de projecao sem repeticao
print(dataelem)

### usar as entradas do datapdos para somar os arquivos de forma apropriada


########################## FUNCAO PARA SOMAR OS PDOS #############################
def sum_PDOS(PREFIX,element, wfcnumber, wfc, fermi, graphtitle, min_x, max_x, min_y, max_y, showgraph, nspin ):
  dosfiles=[]
  if element == 'XX':
    element='.{1,}'
  if wfc == 'X':
    wfc='.'
  if wfcnumber == 'X':
    wfcnumber='[0-9]'

  selat='^'+PREFIX+'.pdos_atm#[0-9]{1,}\('+element+'\)_wfc#'+wfcnumber+'\('+wfc+'\)'
  if wfc == '.':
    wfc=''
  if wfcnumber == '[0-9]':
    wfcnumber=''

  for dfile in glob.glob(PREFIX+'*'):
    print(dfile)
    if re.match(selat, dfile):
      dosfiles.append(dfile) 
  print('DOS files matching regexp:')
  print(dosfiles)
  if len(dosfiles)==0:
    print("ERROR: Provide a (list of) valid DOS file(s)")
    sys.exit()

  ## se fermi nao especificado procurar no arquivo dos na pasta PP
  if fermi == 0 :
    with open('../'+PREFIX+'.dos') as f:
      first_line = f.readline()
      result = re.findall(r"Fermi *[^\w ] *(.*) eV", first_line, re.IGNORECASE | re.MULTILINE)
      result = result[0].split()
      if len(result) > 1 :
        if result[0] == result[1]:
          fermi=round(float(result[0]),3)
        else:
          print("ERROR: spin up and down fermi are different")
      else:
        fermi=round(float(result[0]),3)

    with open('../../out.'+PREFIX+'.nscf') as f:
      for line in f :
          if re.search("highest", line):
            re_fermi = line.split()
            fermi=round(float(re_fermi[6]),3)
          if re.search("Fermi energy", line):
            re_fermi = line.split()
            fermi=round(float(re_fermi[4]),3)
  print('fermi: ',fermi)
    
  
  mat=[]  # matrix with total sum of ldos

  if nspin == 1:
      for i in range(len(dosfiles)):
       mati=[] # temporal matrix for each DOS file "i"
       k=0
       for line in open(dosfiles[i],'r'):
        if len(line) > 10 and line.split()[0] != "#":
            if wfc == 's' or wfc == '':
              mati.append([float(line.split()[0]),float(line.split()[1])])
            if wfc == 'p' :
              mati.append([float(line.split()[0]),float(line.split()[1]),float(line.split()[2]),float(line.split()[3]),float(line.split()[4])])
            if wfc == 'd' :
              mati.append([float(line.split()[0]),float(line.split()[1]),float(line.split()[2]),float(line.split()[3]),float(line.split()[4]),float(line.split()[5]),float(line.split()[6])])
            if wfc == 'f' :
              mati.append([float(line.split()[0]),float(line.split()[1]),float(line.split()[2]),float(line.split()[3]),float(line.split()[4]),float(line.split()[5]),float(line.split()[6]),float(line.split()[7]),float(line.split()[8])])

       if mat == []: # if it is the first dos file, copy total matrix (mat) = the first dos files's data
          mat=mati[:]
       else:
          for j in range(len(mati)): # if it is not the first file, sum values
              if wfc == 's' or wfc == '':
                mat[j]=[mat[j][0],mat[j][1]+mati[j][1]]
              if wfc == 'p':  
                mat[j]=[mat[j][0],mat[j][1]+mati[j][1],mat[j][2]+mati[j][2],mat[j][3]+mati[j][3],mat[j][4]+mati[j][4] ]  
              if wfc == 'd':  
                mat[j]=[mat[j][0],mat[j][1]+mati[j][1],mat[j][2]+mati[j][2],mat[j][3]+mati[j][3],mat[j][4]+mati[j][4],mat[j][5]+mati[j][5],mat[j][6]+mati[j][6] ]  
              if wfc == 'f':  
                mat[j]=[mat[j][0],mat[j][1]+mati[j][1],mat[j][2]+mati[j][2],mat[j][3]+mati[j][3],mat[j][4]+mati[j][4],mat[j][5]+mati[j][5],mat[j][6]+mati[j][6],mat[j][7]+mati[j][7],mat[j][8]+mati[j][8] ]  


      print("...ploting...")
      if wfc == 's' or wfc == '':
        x,y=[],[]    
      if wfc == 'p' :
        x,y,y1,y2,y3=[],[],[],[],[]    
      if wfc == 'd':
        x,y,y1,y2,y3,y4,y5=[],[],[],[],[],[],[]
      if wfc == 'f':
        x,y,y1,y2,y3,y4,y5,y6,y7=[],[],[],[],[],[],[],[],[]

      for i in mat:
        if wfc == 's' or wfc == '':
          x.append(i[0]-fermi)
          y.append(i[1])
        if wfc == 'p':
          x.append(i[0]-fermi)
          y.append(i[1])
          y1.append(i[2])
          y2.append(i[3])
          y3.append(i[4])
        if wfc == 'd':
          x.append(i[0]-fermi)
          y.append(i[1])
          y1.append(i[2])
          y2.append(i[3])
          y3.append(i[4])
          y4.append(i[5])
          y5.append(i[6])
        if wfc == 'f':
          x.append(i[0]-fermi)
          y.append(i[1])
          y1.append(i[2])
          y2.append(i[3])
          y3.append(i[4])
          y4.append(i[5])
          y5.append(i[6])
          y6.append(i[7])
          y7.append(i[8])
      if wfc == 's' or wfc == '':
        x=np.array(x)
        y=np.array(y)
        total=np.stack((x, y), axis=-1)
        np.savetxt('sumpdos_'+PREFIX+'.'+element+wfcnumber+wfc, total, delimiter='', fmt="%.6f %.6f")
        plt.plot(x,y,linewidth=1.0)
        plt.fill(x,y,color='0.8')

      if wfc == 'p' :
        x=np.array(x)
        y=np.array(y)
        y1=np.array(y1)
        y2=np.array(y2)
        y3=np.array(y3)
        total=np.stack((x, y, y1,y2,y3), axis=-1)
        np.savetxt('sumpdos_'+PREFIX+'.'+element+wfcnumber+wfc, total, delimiter='', fmt="%.6f %.6f %.6f %.6f %.6f")
        plt.plot(x,y,linewidth=1.0)
        plt.plot(x,y1,linewidth=1.0, label='$\mathregular{pz}$')
        plt.plot(x,y2,linewidth=1.0, label='$\mathregular{px}$')
        plt.plot(x,y3,linewidth=1.0, label='$\mathregular{py}$')
        plt.fill(x,y,color='0.8')
        plt.fill(x,y1,color='0.9')
        plt.fill(x,y2,color='0.9')
        plt.fill(x,y3,color='0.9')

      if wfc == 'd' :
        x=np.array(x)
        y=np.array(y)
        y1=np.array(y1)
        y2=np.array(y2)
        y3=np.array(y3)
        y4=np.array(y4)
        y5=np.array(y5)
        total=np.stack((x, y, y1,y2,y3,y4,y5), axis=-1)
        np.savetxt('sumpdos_'+PREFIX+'.'+element+wfcnumber+wfc, total, delimiter='', fmt="%.6f %.6f %.6f %.6f %.6f %.6f %.6f")
        plt.plot(x,y,linewidth=1.0)
        plt.plot(x,y1,linewidth=1.0, label='$\mathregular{dz^2}$')
        plt.plot(x,y2,linewidth=1.0, label='$\mathregular{dzx}$')
        plt.plot(x,y3,linewidth=1.0, label='$\mathregular{dzy}$')
        plt.plot(x,y4,linewidth=1.0, label='$\mathregular{dx^2-y^2}$')
        plt.plot(x,y5,linewidth=1.0, label='$\mathregular{dxy}$')
        plt.fill(x,y,color='0.8')
        plt.fill(x,y1,color='0.9')
        plt.fill(x,y2,color='0.9')
        plt.fill(x,y3,color='0.9')
        plt.fill(x,y4,color='0.9')
        plt.fill(x,y5,color='0.9')

      if wfc == 'f' :
        x=np.array(x)
        y=np.array(y)
        y1=np.array(y1)
        y2=np.array(y2)
        y3=np.array(y3)
        y4=np.array(y4)
        y5=np.array(y5)
        y6=np.array(y6)
        y7=np.array(y7)
        total=np.stack((x, y, y1,y2,y3,y4,y5,y6,y7), axis=-1)
        np.savetxt('sumpdos_'+PREFIX+'.'+element+wfcnumber+wfc, total, delimiter='', fmt="%.6f %.6f %.6f %.6f %.6f %.6f %.6f %.6f %.6f")
        plt.plot(x,y,linewidth=1.0, label='f' )
        plt.plot(x,y1,linewidth=1.0, label='f1')
        plt.plot(x,y2,linewidth=1.0, label='f2')
        plt.plot(x,y3,linewidth=1.0, label='f3')
        plt.plot(x,y4,linewidth=1.0, label='f4')
        plt.plot(x,y5,linewidth=1.0, label='f5')
        plt.plot(x,y6,linewidth=1.0, label='f6')
        plt.plot(x,y7,linewidth=1.0, label='f7')
        plt.fill(x,y,color='0.8')
        plt.fill(x,y1,color='0.9')
        plt.fill(x,y2,color='0.9')
        plt.fill(x,y3,color='0.9')
        plt.fill(x,y4,color='0.9')
        plt.fill(x,y5,color='0.9')
        plt.fill(x,y6,color='0.9')
        plt.fill(x,y7,color='0.9')
      # if there is matplotlib, generate a plot with it
      plt.title(graphtitle)
      plt.xlabel('E (eV)')
      plt.ylabel('States')
      plt.legend(loc='upper right')
    #  plt.grid(True)
      # plt.rcParams.update({'font.size': 22})
      if min_x and max_x:
       fromx,tox=min_x,max_x 
      margin=max(y)*0.3
      plt.axis([fromx, tox, -margin, max(y)+margin])

      fig = plt.gcf()
      if showgraph == 1:
        plt.show()   
      fig.savefig(PREFIX+'_PDOS-'+element+wfcnumber+wfc+'.eps', format='eps', dpi=1000)
      fig.clf()
      plt.close()

  if nspin == 2:
      for i in range(len(dosfiles)):
       mati=[] # temporal matrix for each DOS file "i"
       k=0
       for line in open(dosfiles[i],'r'):
        if len(line) > 10 and line.split()[0] != "#":
            if wfc == 's' or wfc == '':
              mati.append([float(line.split()[0]),float(line.split()[1]),float(line.split()[2]),float(line.split()[3]),float(line.split()[4])])
            if wfc == 'p' :
              mati.append([float(line.split()[0]),float(line.split()[1]),float(line.split()[2]),float(line.split()[3]),float(line.split()[4]),float(line.split()[5]),float(line.split()[6]),float(line.split()[7]),float(line.split()[8])])
            if wfc == 'd' :
              mati.append([float(line.split()[0]),float(line.split()[1]),float(line.split()[2]),float(line.split()[3]),float(line.split()[4]),float(line.split()[5]),float(line.split()[6]),float(line.split()[7]),float(line.split()[8]),float(line.split()[9]),float(line.split()[10]),float(line.split()[11]),float(line.split()[12])])
            if wfc == 'f' :
              mati.append([float(line.split()[0]),float(line.split()[1]),float(line.split()[2]),float(line.split()[3]),float(line.split()[4]),float(line.split()[5]),float(line.split()[6]),float(line.split()[7]),float(line.split()[8]),float(line.split()[9]),float(line.split()[10]),float(line.split()[11]),float(line.split()[12]),float(line.split()[13]),float(line.split()[14]),float(line.split()[15]),float(line.split()[16])])
       if mat == []: # if it is the first dos file, copy total matrix (mat) = the first dos files's data
          mat=mati[:]
       else:
          for j in range(len(mati)): # if it is not the first file, sum values
              if wfc == 's' or wfc == '':
                mat[j]=[mat[j][0],mat[j][1]+mati[j][1],mat[j][2]+mati[j][2]]
              if wfc == 'p':  
                mat[j]=[mat[j][0],mat[j][1]+mati[j][1],mat[j][2]+mati[j][2],mat[j][3]+mati[j][3],mat[j][4]+mati[j][4],mat[j][5]+mati[j][5],mat[j][6]+mati[j][6],mat[j][7]+mati[j][7],mat[j][8]+mati[j][8] ] 
              if wfc == 'd':  
                mat[j]=[mat[j][0],mat[j][1]+mati[j][1],mat[j][2]+mati[j][2],mat[j][3]+mati[j][3],mat[j][4]+mati[j][4],mat[j][5]+mati[j][5],mat[j][6]+mati[j][6],mat[j][7]+mati[j][7],mat[j][8]+mati[j][8],mat[j][9]+mati[j][9],mat[j][10]+mati[j][10],mat[j][11]+mati[j][11],mat[j][12]+mati[j][12] ]  
              if wfc == 'f':  
                mat[j]=[mat[j][0],mat[j][1]+mati[j][1],mat[j][2]+mati[j][2],mat[j][3]+mati[j][3],mat[j][4]+mati[j][4],mat[j][5]+mati[j][5],mat[j][6]+mati[j][6],mat[j][7]+mati[j][7],mat[j][8]+mati[j][8],mat[j][9]+mati[j][9],mat[j][10]+mati[j][10],mat[j][11]+mati[j][11],mat[j][12]+mati[j][12],mat[j][13]+mati[j][13],mat[j][14]+mati[j][14],mat[j][15]+mati[j][15],mat[j][16]+mati[j][16] ]  


      print("...ploting...")
      if wfc == 's' or wfc == '':
        x,y,yu=[],[],[]    
      if wfc == 'p' :
        x,y,yu,y1,y1u,y2,y2u,y3,y3u=[],[],[],[],[],[],[],[],[]    
      if wfc == 'd':
        x,y,yu,y1,y1u,y2,y2u,y3,y3u,y4,y4u,y5,y5u=[],[],[],[],[],[],[],[],[],[],[],[],[]
      if wfc == 'f':
        x,y,yu,y1,y1u,y2,y2u,y3,y3u,y4,y4u,y5,y5u,y6,y6u,y7,y7u=[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]

      for i in mat:
        if wfc == 's' or wfc == '':
          x.append(i[0]-fermi)
          y.append(i[1])
          yu.append(i[2])
        if wfc == 'p':
          x.append(i[0]-fermi)
          y.append(i[1])
          yu.append(i[2])
          y1.append(i[3])
          y1u.append(i[4])
          y2.append(i[5])
          y2u.append(i[6])
          y3.append(i[7])
          y3u.append(i[8])
        if wfc == 'd':
          x.append(i[0]-fermi)
          y.append(i[1])
          yu.append(i[2])
          y1.append(i[3])
          y1u.append(i[4])
          y2.append(i[5])
          y2u.append(i[6])
          y3.append(i[7])
          y3u.append(i[8])
          y4.append(i[9])
          y4u.append(i[10])
          y5.append(i[11])
          y5u.append(i[12])
        if wfc == 'f':
          x.append(i[0]-fermi)
          y.append(i[1])
          yu.append(i[2])
          y1.append(i[3])
          y1u.append(i[4])
          y2.append(i[5])
          y2u.append(i[6])
          y3.append(i[7])
          y3u.append(i[8])
          y4.append(i[9])
          y4u.append(i[10])
          y5.append(i[11])
          y5u.append(i[12])
          y6.append(i[13])
          y6u.append(i[14])
          y7.append(i[15])
          y7u.append(i[16])
      if wfc == 's' or wfc == '':
        x=np.array(x)
        y=np.array(y)
        yu=np.array(yu)
        total=np.stack((x, y, yu), axis=-1)
        np.savetxt('sumpdos_'+PREFIX+'.'+element+wfcnumber+wfc, total, delimiter='', fmt="%.6f %.6f %.6f")
        plt.plot(x,y,linewidth=1.0)
        plt.fill(x,y,color='0.8')
        plt.plot(x,-yu,linewidth=1.0)
        plt.fill(x,-yu,color='0.7')

      if wfc == 'p' :
        x=np.array(x)
        y=np.array(y)
        yu=np.array(yu)
        y1=np.array(y1)
        y1u=np.array(y1u)
        y2=np.array(y2)
        y2u=np.array(y2u)
        y3=np.array(y3)
        y3u=np.array(y3u)
        total=np.stack((x, y, yu, y1, y1u, y2, y2u, y3, y3u), axis=-1)
        np.savetxt('sumpdos_'+PREFIX+'.'+element+wfcnumber+wfc, total, delimiter='', fmt="%.6f %.6f %.6f %.6f %.6f %.6f %.6f %.6f %.6f")
        plt.plot(x,y,linewidth=1.0)
        plt.plot(x,y1,linewidth=1.0, label='$\mathregular{pz}$')
        plt.plot(x,y2,linewidth=1.0, label='$\mathregular{px}$')
        plt.plot(x,y3,linewidth=1.0, label='$\mathregular{py}$')
        plt.fill(x,y,color='0.8')
        plt.fill(x,y1,color='0.9')
        plt.fill(x,y2,color='0.9')
        plt.fill(x,y3,color='0.9')
        plt.plot(x,-yu,linewidth=1.0)
        plt.plot(x,-y1u,linewidth=1.0, label='$\mathregular{pz}$')
        plt.plot(x,-y2u,linewidth=1.0, label='$\mathregular{px}$')
        plt.plot(x,-y3u,linewidth=1.0, label='$\mathregular{py}$')
        plt.fill(x,-yu,color='0.7')
        plt.fill(x,-y1u,color='0.8')
        plt.fill(x,-y2u,color='0.8')
        plt.fill(x,-y3u,color='0.8')

      if wfc == 'd' :
        x=np.array(x)
        y=np.array(y)
        yu=np.array(yu)
        y1=np.array(y1)
        y1u=np.array(y1u)
        y2=np.array(y2)
        y2u=np.array(y2u)
        y3=np.array(y3)
        y3u=np.array(y3u)
        y4=np.array(y4)
        y4u=np.array(y4u)
        y5=np.array(y5)
        y5u=np.array(y5u)
        total=np.stack((x, y, yu, y1, y1u, y2, y2u, y3, y3u, y4, y4u, y5, y5u), axis=-1)
        np.savetxt('sumpdos_'+PREFIX+'.'+element+wfcnumber+wfc, total, delimiter='', fmt="%.6f %.6f %.6f %.6f %.6f %.6f %.6f %.6f %.6f %.6f %.6f %.6f %.6f")
        plt.plot(x,y,linewidth=1.0)
        plt.plot(x,y1,linewidth=1.0, label='$\mathregular{dz^2}$')
        plt.plot(x,y2,linewidth=1.0, label='$\mathregular{dzx}$')
        plt.plot(x,y3,linewidth=1.0, label='$\mathregular{dzy}$')
        plt.plot(x,y4,linewidth=1.0, label='$\mathregular{dx^2-y^2}$')
        plt.plot(x,y5,linewidth=1.0, label='$\mathregular{dxy}$')
        plt.fill(x,y,color='0.8')
        plt.fill(x,y1,color='0.9')
        plt.fill(x,y2,color='0.9')
        plt.fill(x,y3,color='0.9')
        plt.fill(x,y4,color='0.9')
        plt.fill(x,y5,color='0.9')
        plt.plot(x,-yu,linewidth=1.0)
        plt.plot(x,-y1u,linewidth=1.0, label='$\mathregular{dz^2}$')
        plt.plot(x,-y2u,linewidth=1.0, label='$\mathregular{dzx}$')
        plt.plot(x,-y3u,linewidth=1.0, label='$\mathregular{dzy}$')
        plt.plot(x,-y4u,linewidth=1.0, label='$\mathregular{dx^2-y^2}$')
        plt.plot(x,-y5u,linewidth=1.0, label='$\mathregular{dxy}$')
        plt.fill(x,-yu,color='0.7')
        plt.fill(x,-y1u,color='0.8')
        plt.fill(x,-y2u,color='0.8')
        plt.fill(x,-y3u,color='0.8')
        plt.fill(x,-y4u,color='0.8')
        plt.fill(x,-y5u,color='0.8')

      if wfc == 'f' :
        x=np.array(x)
        y=np.array(y)
        yu=np.array(yu)
        y1=np.array(y1)
        y1u=np.array(y1u)
        y2=np.array(y2)
        y2u=np.array(y2u)
        y3=np.array(y3)
        y3u=np.array(y3u)
        y4=np.array(y4)
        y4u=np.array(y4u)
        y5=np.array(y5)
        y5u=np.array(y5u)
        y6=np.array(y6)
        y6u=np.array(y6u)
        y7=np.array(y7)
        y7u=np.array(y7u)
        total=np.stack((x, y, yu, y1, y1u, y2, y2u, y3, y3u, y4, y4u, y5, y5u, y6, y6u, y7, y7u), axis=-1)
        np.savetxt('sumpdos_'+PREFIX+'.'+element+wfcnumber+wfc, total, delimiter='', fmt="%.6f %.6f %.6f %.6f %.6f %.6f %.6f %.6f %.6f %.6f %.6f %.6f %.6f %.6f %.6f %.6f %.6f")
        plt.plot(x,y,linewidth=1.0, label='f' )
        plt.plot(x,y1,linewidth=1.0, label='f1')
        plt.plot(x,y2,linewidth=1.0, label='f2')
        plt.plot(x,y3,linewidth=1.0, label='f3')
        plt.plot(x,y4,linewidth=1.0, label='f4')
        plt.plot(x,y5,linewidth=1.0, label='f5')
        plt.plot(x,y6,linewidth=1.0, label='f6')
        plt.plot(x,y7,linewidth=1.0, label='f7')
        plt.fill(x,y,color='0.8')
        plt.fill(x,y1,color='0.9')
        plt.fill(x,y2,color='0.9')
        plt.fill(x,y3,color='0.9')
        plt.fill(x,y4,color='0.9')
        plt.fill(x,y5,color='0.9')
        plt.fill(x,y6,color='0.9')
        plt.fill(x,y7,color='0.9')
        plt.plot(x,-yu,linewidth=1.0, label='f' )
        plt.plot(x,-y1u,linewidth=1.0, label='f1')
        plt.plot(x,-y2u,linewidth=1.0, label='f2')
        plt.plot(x,-y3u,linewidth=1.0, label='f3')
        plt.plot(x,-y4u,linewidth=1.0, label='f4')
        plt.plot(x,-y5u,linewidth=1.0, label='f5')
        plt.plot(x,-y6u,linewidth=1.0, label='f6')
        plt.plot(x,-y7u,linewidth=1.0, label='f7')
        plt.fill(x,-yu,color='0.7')
        plt.fill(x,-y1u,color='0.8')
        plt.fill(x,-y2u,color='0.8')
        plt.fill(x,-y3u,color='0.8')
        plt.fill(x,-y4u,color='0.8')
        plt.fill(x,-y5u,color='0.8')
        plt.fill(x,-y6u,color='0.8')
        plt.fill(x,-y7u,color='0.8')
      # if there is matplotlib, generate a plot with it
      plt.title(graphtitle)
      plt.xlabel('E (eV)')
      plt.ylabel('States')
      plt.legend(loc='upper right')
    #  plt.grid(True)
      # plt.rcParams.update({'font.size': 22})
      if min_x and max_x:
       fromx,tox=min_x,max_x 
      margin=max(y)*0.3
      plt.axis([fromx, tox, min(-y)-margin, max(y)+margin])

      fig = plt.gcf()
      if showgraph == 1:
        plt.show()   
      fig.savefig(PREFIX+'_PDOS-'+element+wfcnumber+wfc+'.eps', format='eps', dpi=1000)
      fig.clf()
      plt.close()

####################################################################################
####################################################################################

########### GERAR ARQUIVOS DE PROJECAO ORBITAIS E ATOMICOS #############

for projection in datapdos:
  sum_PDOS(PREFIX, projection[0], projection[1], projection[2], fermi, graphtitle, min_x, max_x, min_y, max_y, showgraph, nspin)
print(dataelem)
for projection in dataelem:
  sum_PDOS(PREFIX, projection[0], 'X', 'X', fermi, graphtitle, min_x, max_x, min_y, max_y, showgraph, nspin)  
####################################################################################

EOF

python3 sumpdos.py $INPUT

cat > plotPDOS.py << 'EOF'
#! /usr/bin/python
import sys
import os
import fnmatch, re
import linecache
import matplotlib
import matplotlib.pyplot as plt
import glob
import numpy as np
from cycler import cycler

### se alinha do nspin comeca com ! deveria ser ignorado
### implementar para qualquer variavel

### funcao para fazer um grep em arquivos
def grep(filename,regex):
      for file in glob.iglob(filename):
         for line in open(file, 'r'):
            if re.search(regex, line):
               return line

PREFIX=str(sys.argv[1])

# Some default variables
fermi=0
nspin=1
graphtitle=""
min_x,max_x=-2,7
min_y,max_y="",""
wfcnumber='X'
wfc='X'
showgraph=0

######### PLOTTING ONLY  ##################
### plotar DOStotal com proj de cada orbital
  ## se fermi nao especificado procurar no arquivo dos na pasta PP
if fermi == 0 :
    with open('../'+PREFIX+'.dos') as f:
      first_line = f.readline()
      result = re.findall(r"Fermi *[^\w ] *(.*) eV", first_line, re.IGNORECASE | re.MULTILINE)
      result = result[0].split()
      if len(result) > 1 :
        if result[0] == result[1]:
          fermi=round(float(result[0]),3)
        else:
          print("ERROR: spin up and down fermi are different")
      else:
        fermi=round(float(result[0]),3)

    with open('../../out.'+PREFIX+'.nscf') as f:
      for line in f :
          if re.search("highest", line):
            re_fermi = line.split()
            fermi=round(float(re_fermi[6]),3)
          if re.search("Fermi energy", line):
            re_fermi = line.split()
            fermi=round(float(re_fermi[4]),3)
  print('fermi: ',fermi)

## LER DADOS DO DOS
dostotdata =  np.genfromtxt(PREFIX+'.pdos_tot')
energy = dostotdata[:,0]-fermi
dostot = dostotdata[:,1]

### pegar nspin do input do QE
subject=grep('../../'+PREFIX+'.scf.in','nspin')
#print('subject:', subject)
#print(subject.strip().startswith('!'))
if subject != None and not subject.strip().startswith('!') :
    match = re.search("nspin\s{0,}.\s{0,}(\d{1,})", subject)  ## . para ignorar o = entre paranteses o que quer dar match, \d{1,} significa uma ou mais ocorrencias de digito, igualmente \s{0,} vai considerar nenhum ou algum espaco
    if match:
        nspin = int(match.group(1))
    else:
        print('Error: could not find npin in file. Using nspin=1.')
else:
    print('Error: could not find npin in file. Using nspin=1.')


######## CALCULO DO GAP ################################
# indice do nivel de fermi no DOS
## energy == -0.05 para conseguir encontrar o gap em sistemas que a energia
## de fermi tem um dos muito pequeno.
index_fermi = np.nonzero(energy==0)[0]
# pega o DOS acima do nivel de Fermi
DOS_overfermi = dostot[energy>-0.5] 
# pega os indices do DOS com valor consideravel
index_DOS=np.nonzero(DOS_overfermi>0.1)[0]
for i in range(len(index_DOS)-1):
#se os indices apresentam uma descontinuidade e a regiao de gap
  if (index_DOS[i] != index_DOS[i+1]-1) : #and (index_DOS[i] > 500 ):   
    idxVB=index_DOS[i]  # indice da VB
    idxCB=index_DOS[i+1] # indice da CB
    break  # so pega a primeira descontinuidade
try:
  idxVB
except:
  print("Nao encontrou GAP!")
  GAP=0
else:
  print("Existe gap, calculando...")
  index_topVB = index_fermi  # indice da VB no DOS inteiro
  index_botCB = idxCB-idxVB+index_fermi  # indice da CB no DOS inteiro
# index_topVB = idxVB+index_fermi  # indice da VB no DOS inteiro
# index_botCB = idxCB+index_fermi  # indice da CB no DOS inteiro
  #print(index_topVB,index_botCB)
  GAP=energy[index_botCB[0]]-energy[index_topVB[0]]
   #gap e a subtraçao das energias
  print('Valor do GAP pelo DOS:',GAP,' eV.')
# ax.axvline(x=0, color='black',linestyle='--')  ## linha do nivel de FERMI

if not os.path.isfile('../../gap_nscf'):
  gap_nscf = GAP
  print('There is no NSCF gap, using gap calculated from DOS.')
else :
  gap_nscf = float(np.genfromtxt('../../gap_nscf'))
  print('Gap given by NSCF calculation will be used.')

fig = plt.figure()
ax = fig.add_subplot(111)

ax.plot(energy,dostot,linewidth=1.0, label='Total DOS')
ax.fill(energy,dostot,color='0.8')
##################################################################


# funcao para pegar os sumpdos_ de interesse
# agrupa os arquivos em pdosfiles
pdosfiles= [ ]
for file in glob.glob('sumpdos_'+PREFIX+'.*'):
#    print(file)
    re_file = re.findall('sumpdos_'+PREFIX+'.[a-zA-Z]{1,}[0-9][a-z]', file)
 #   print(re_file)
    if re_file != [] :
      pdosfiles.append(re_file[0])
#print(pdosfiles)

for file in pdosfiles :
  ### encontrar os dados do orbital do arquivo em quetao
  element = re.findall('sumpdos_'+PREFIX+'.([a-zA-Z]{1,})', file)
  wfcnumber = re.findall('sumpdos_'+PREFIX+'.[a-zA-Z]{1,}([0-9])', file)
  wfc = re.findall('sumpdos_'+PREFIX+'.[a-zA-Z]{1,}[0-9]([a-z])', file)
#  print(file)
  ### importa os dados para plotar
  pdosdata = np.genfromtxt(file)
  pdos = pdosdata[:,1]
  if nspin == 2:
      pdosup = pdosdata[:,2]
  ax.plot(energy,pdos,linewidth=1.0, label=element[0]+wfcnumber[0]+wfc[0])
  if nspin == 2:
      ax.plot(energy,-pdosup,linewidth=1.0, label=element[0]+wfcnumber[0]+wfc[0])
plt.title(graphtitle)
plt.xlabel('E (eV)')
plt.ylabel('States')
plt.legend(loc='upper right')
# plt.grid(True)
# plt.rcParams.update({'font.size': 22})
if min_x and max_x:
 fromx,tox=min_x,max_x 
DOSMAX=max(dostot[(energy>min_x) & (energy<max_x)])
margin=DOSMAX*0.4
ax.axis([fromx, tox, -margin, DOSMAX + margin])  
if nspin == 2:
  ax.axis([fromx, tox, -DOSMAX-margin, DOSMAX + margin])  
### FLECHA DUPLA INDICANDO BAND GAP
if (GAP != 0) and (GAP > 1.3 ):
  ax.arrow(energy[index_topVB[0]], 0.04*DOSMAX, GAP, 0, head_width=0.6, head_length=0.5, color = 'black',  length_includes_head = True)
  ax.arrow(energy[index_botCB[0]], 0.04*DOSMAX, -GAP, 0, head_width=0.6, head_length=0.5, color = 'black',  length_includes_head = True)

  ax.text(energy[index_topVB[0]]+GAP/2, 0.14*DOSMAX, r'$E_g= $'+str(round(gap_nscf,2))+' eV', horizontalalignment='center')

if (GAP != 0) and (GAP < 1.3 ):
  ax.arrow(energy[index_topVB[0]], 0.04*DOSMAX, GAP, 0, head_width=0.3, head_length=0.2, color = 'black',  length_includes_head = True)
  ax.arrow(energy[index_botCB[0]], 0.04*DOSMAX, -GAP, 0, head_width=0.3, head_length=0.2, color = 'black',  length_includes_head = True)

  ax.text(3, 0.92*DOSMAX, r'$E_g= $'+str(round(gap_nscf,2))+' eV', horizontalalignment='center')

fig = plt.gcf()
if showgraph == 1:
  plt.show()   
fig.savefig(PREFIX+'_PDOS'+'.eps', format='eps', dpi=1000)  ## vai plotar PDOS de cada orbital, sem discriminar o m, up e down em cima e embaixo caso spinpolarizado
fig.clf()
plt.close()




#####################################################
### plotar DOStotal proj cada orbital e cada m embaixo
#####################################################
if nspin == 1:
    NUM_COLORS=30
    cm = plt.get_cmap('gist_rainbow')
    fig = plt.figure()
    ax = fig.add_subplot(111)
    ax.plot(energy,dostot,linewidth=1.0, label='Total DOS')
    ax.fill(energy,dostot,color='0.8')
    ax.set_prop_cycle(cycler(color=[cm(1.*i/NUM_COLORS) for i in range(NUM_COLORS)]))
    # funcao para pegar os sumpdos_ de interesse
    # agrupa os arquivos em pdosfiles
    pdosfiles= [ ]
    for file in glob.glob('sumpdos_'+PREFIX+'.*'):
    #  print(file)
        re_file = re.findall('sumpdos_'+PREFIX+'.[a-zA-Z]{1,}[0-9][a-z]', file)
    #   print(re_file)
        if re_file != [] :
          pdosfiles.append(re_file[0])
    # print(pdosfiles)
    # funcao para pegar os sumpdos_ de interesse
    # agrupa os arquivos em pdosfiles

    for file in pdosfiles :
      ### encontrar os dados do orbital do arquivo em quetao
      element = re.findall('sumpdos_'+PREFIX+'.([a-zA-Z]{1,})', file)[0]
      wfcnumber = re.findall('sumpdos_'+PREFIX+'.[a-zA-Z]{1,}([0-9])', file)[0]
      wfc = re.findall('sumpdos_'+PREFIX+'.[a-zA-Z]{1,}[0-9]([a-z])', file)[0]

      pdosdata = np.genfromtxt(file)
      pdos = pdosdata[:,1]
      try:
        pdos_p1 = -pdosdata[:,2]
        pdos_p2 = -pdosdata[:,3]
        pdos_p3 = -pdosdata[:,4]
        try:
          pdos_p4 = -pdosdata[:,5]
          pdos_p5 = -pdosdata[:,6]
          try:
            pdos_p6 = -pdosdata[:,7]
            pdos_p7 = -pdosdata[:,8]
          except:
            pass
        except:
          pass
      except:
        pass
      ax.plot(energy,pdos,linewidth=1.0, label=element+wfcnumber+wfc)
      if wfc == 'p' :
        ax.plot(energy,pdos_p1,linewidth=1.0, linestyle=':',label=element+wfcnumber+'$\mathregular{pz}$')
        ax.plot(energy,pdos_p2,linewidth=1.0, linestyle='--',label=element+wfcnumber+'$\mathregular{px}$')
        ax.plot(energy,pdos_p3,linewidth=1.0, linestyle='-.',label=element+wfcnumber+'$\mathregular{py}$')
      if wfc == 'd' :
        ax.plot(energy,pdos_p1,linewidth=1.0,linestyle=':',label=element+wfcnumber+'$\mathregular{dz^2}$')
        ax.plot(energy,pdos_p2,linewidth=1.0,linestyle='--',label=element+wfcnumber+'$\mathregular{dzx}$')
        ax.plot(energy,pdos_p3,linewidth=1.0,linestyle='-.',label=element+wfcnumber+'$\mathregular{dzy}$')
        ax.plot(energy,pdos_p4,linewidth=1.0,linestyle=':',label=element+wfcnumber+'$\mathregular{dx^2-y^2}$')
        ax.plot(energy,pdos_p5,linewidth=1.0,linestyle='-',label=element+wfcnumber+'$\mathregular{dxy}$')
      if wfc == 'f' :
        ax.plot(energy,pdos_p1,linewidth=1.0,linestyle=':',label=element+wfcnumber+'$\mathregular{f1}$')
        ax.plot(energy,pdos_p2,linewidth=1.0,linestyle='--',label=element+wfcnumber+'$\mathregular{f2}$')
        ax.plot(energy,pdos_p3,linewidth=1.0,linestyle='-.',label=element+wfcnumber+'$\mathregular{f3}$')
        ax.plot(energy,pdos_p4,linewidth=1.0,linestyle=':',label=element+wfcnumber+'$\mathregular{f4}$')
        ax.plot(energy,pdos_p5,linewidth=1.0,linestyle='-',label=element+wfcnumber+'$\mathregular{f5}$')
        ax.plot(energy,pdos_p6,linewidth=1.0,linestyle='-.',label=element+wfcnumber+'$\mathregular{f6}$')
        ax.plot(energy,pdos_p7,linewidth=1.0,linestyle='--',label=element+wfcnumber+'$\mathregular{f7}$')
    plt.title(graphtitle)
    plt.xlabel('E (eV)')
    plt.ylabel('States')


    # Shrink current axis by 20%
    box = ax.get_position()
    ax.set_position([box.x0, box.y0, box.width * 0.8, box.height])
    # Put a legend to the right of the current axis
    ax.legend(loc='center left', bbox_to_anchor=(1, 0.5))

    #plt.legend(loc='upper right')
    # plt.grid(True)
    # plt.rcParams.update({'font.size': 22})
    if min_x and max_x:
     fromx,tox=min_x,max_x 
    margin=max(dostot[(energy>min_x) & (energy<max_x)])*0.4
    ax.axis([fromx, tox, min(dostot[(energy>min_x) & (energy<max_x)])-margin, max(dostot[(energy>min_x) & (energy<max_x)]) + margin])  


    DOSMAX=max(dostot[(energy>min_x) & (energy<max_x)])
    ### FLECHA DUPLA INDICANDO BAND GAP
    if (GAP != 0) and (GAP > 1.3 ):
      ax.arrow(energy[index_topVB[0]], 0.04*DOSMAX, GAP, 0, head_width=0.6, head_length=0.5, color = 'black',  length_includes_head = True)
      ax.arrow(energy[index_botCB[0]], 0.04*DOSMAX, -GAP, 0, head_width=0.6, head_length=0.5, color = 'black',  length_includes_head = True)

      ax.text(energy[index_topVB[0]]+GAP/2, 0.14*DOSMAX, r'$E_g= $'+str(round(gap_nscf,2))+' eV', horizontalalignment='center')

    if (GAP != 0) and (GAP < 1.3 ):
      ax.arrow(energy[index_topVB[0]], 0.04*DOSMAX, GAP, 0, head_width=0.3, head_length=0.2, color = 'black',  length_includes_head = True)
      ax.arrow(energy[index_botCB[0]], 0.04*DOSMAX, -GAP, 0, head_width=0.3, head_length=0.2, color = 'black',  length_includes_head = True)

      ax.text(3, 0.92*DOSMAX, r'$E_g= $'+str(round(gap_nscf,2))+' eV', horizontalalignment='center')

    fig = plt.gcf()
    if showgraph == 1:
      ax.show()  
    fig.savefig(PREFIX+'_PDOS_orbitais_m'+'.eps', format='eps', dpi=1000)
    fig.clf()
    plt.close()

if nspin == 2:
    NUM_COLORS=30
    cm = plt.get_cmap('gist_rainbow')
    fig = plt.figure()
    ax = fig.add_subplot(111)
    ax.plot(energy,dostot,linewidth=1.0, label='Total DOS')
    ax.fill(energy,dostot,color='0.8')
    ax.set_prop_cycle(cycler(color=[cm(1.*i/NUM_COLORS) for i in range(NUM_COLORS)]))
    # funcao para pegar os sumpdos_ de interesse
    # agrupa os arquivos em pdosfiles
    pdosfiles= [ ]
    for file in glob.glob('sumpdos_'+PREFIX+'.*'):
    #  print(file)
        re_file = re.findall('sumpdos_'+PREFIX+'.[a-zA-Z]{1,}[0-9][a-z]', file)
    #   print(re_file)
        if re_file != [] :
          pdosfiles.append(re_file[0])
    # print(pdosfiles)
    # funcao para pegar os sumpdos_ de interesse
    # agrupa os arquivos em pdosfiles

    for file in pdosfiles :
      ### encontrar os dados do orbital do arquivo em quetao
      element = re.findall('sumpdos_'+PREFIX+'.([a-zA-Z]{1,})', file)[0]
      wfcnumber = re.findall('sumpdos_'+PREFIX+'.[a-zA-Z]{1,}([0-9])', file)[0]
      wfc = re.findall('sumpdos_'+PREFIX+'.[a-zA-Z]{1,}[0-9]([a-z])', file)[0]

      pdosdata = np.genfromtxt(file)
      pdos = pdosdata[:,1]
      pdosup = pdosdata[:,2]
      try:
        pdos_p1 = -pdosdata[:,3]
        pdosup_p1 = -pdosdata[:,4]
        pdos_p2 = -pdosdata[:,5]
        pdosup_p2 = -pdosdata[:,6]
        pdos_p3 = -pdosdata[:,7]
        pdosup_p3 = -pdosdata[:,8]
        try:
          pdos_p4 = -pdosdata[:,9]
          pdosup_p4 = -pdosdata[:,10]
          pdos_p5 = -pdosdata[:,11]
          pdosup_p5 = -pdosdata[:,12]
          try:
            pdos_p6 = -pdosdata[:,13]
            pdosup_p6 = -pdosdata[:,14]
            pdos_p7 = -pdosdata[:,15]
            pdosup_p7 = -pdosdata[:,16]
          except:
            pass
        except:
          pass
      except:
        pass
    ### plot pdosdown
      ax.plot(energy,pdos,linewidth=1.0, label=element+wfcnumber+wfc)
      if wfc == 'p' :
        ax.plot(energy,pdos_p1,linewidth=1.0, linestyle=':',label=element+wfcnumber+'$\mathregular{pz}$')
        ax.plot(energy,pdos_p2,linewidth=1.0, linestyle='--',label=element+wfcnumber+'$\mathregular{px}$')
        ax.plot(energy,pdos_p3,linewidth=1.0, linestyle='-.',label=element+wfcnumber+'$\mathregular{py}$')
      if wfc == 'd' :
        ax.plot(energy,pdos_p1,linewidth=1.0,linestyle=':',label=element+wfcnumber+'$\mathregular{dz^2}$')
        ax.plot(energy,pdos_p2,linewidth=1.0,linestyle='--',label=element+wfcnumber+'$\mathregular{dzx}$')
        ax.plot(energy,pdos_p3,linewidth=1.0,linestyle='-.',label=element+wfcnumber+'$\mathregular{dzy}$')
        ax.plot(energy,pdos_p4,linewidth=1.0,linestyle=':',label=element+wfcnumber+'$\mathregular{dx^2-y^2}$')
        ax.plot(energy,pdos_p5,linewidth=1.0,linestyle='-',label=element+wfcnumber+'$\mathregular{dxy}$')
      if wfc == 'f' :
        ax.plot(energy,pdos_p1,linewidth=1.0,linestyle=':',label=element+wfcnumber+'$\mathregular{f1}$')
        ax.plot(energy,pdos_p2,linewidth=1.0,linestyle='--',label=element+wfcnumber+'$\mathregular{f2}$')
        ax.plot(energy,pdos_p3,linewidth=1.0,linestyle='-.',label=element+wfcnumber+'$\mathregular{f3}$')
        ax.plot(energy,pdos_p4,linewidth=1.0,linestyle=':',label=element+wfcnumber+'$\mathregular{f4}$')
        ax.plot(energy,pdos_p5,linewidth=1.0,linestyle='-',label=element+wfcnumber+'$\mathregular{f5}$')
        ax.plot(energy,pdos_p6,linewidth=1.0,linestyle='-.',label=element+wfcnumber+'$\mathregular{f6}$')
        ax.plot(energy,pdos_p7,linewidth=1.0,linestyle='--',label=element+wfcnumber+'$\mathregular{f7}$')
    plt.title(graphtitle)
    plt.xlabel('E (eV)')
    plt.ylabel('States')


    # Shrink current axis by 20%
    box = ax.get_position()
    ax.set_position([box.x0, box.y0, box.width * 0.8, box.height])
    # Put a legend to the right of the current axis
    ax.legend(loc='center left', bbox_to_anchor=(1, 0.5))

    #plt.legend(loc='upper right')
    # plt.grid(True)
    # plt.rcParams.update({'font.size': 22})
    if min_x and max_x:
     fromx,tox=min_x,max_x 
    margin=max(dostot[(energy>min_x) & (energy<max_x)])*0.4
    ax.axis([fromx, tox, min(dostot[(energy>min_x) & (energy<max_x)])-margin, max(dostot[(energy>min_x) & (energy<max_x)]) + margin])  


    DOSMAX=max(dostot[(energy>min_x) & (energy<max_x)])
    ### FLECHA DUPLA INDICANDO BAND GAP
    if (GAP != 0) and (GAP > 1.3 ):
      ax.arrow(energy[index_topVB[0]], 0.04*DOSMAX, GAP, 0, head_width=0.6, head_length=0.5, color = 'black',  length_includes_head = True)
      ax.arrow(energy[index_botCB[0]], 0.04*DOSMAX, -GAP, 0, head_width=0.6, head_length=0.5, color = 'black',  length_includes_head = True)

      ax.text(energy[index_topVB[0]]+GAP/2, 0.14*DOSMAX, r'$E_g= $'+str(round(gap_nscf,2))+' eV', horizontalalignment='center')

    if (GAP != 0) and (GAP < 1.3 ):
      ax.arrow(energy[index_topVB[0]], 0.04*DOSMAX, GAP, 0, head_width=0.3, head_length=0.2, color = 'black',  length_includes_head = True)
      ax.arrow(energy[index_botCB[0]], 0.04*DOSMAX, -GAP, 0, head_width=0.3, head_length=0.2, color = 'black',  length_includes_head = True)

      ax.text(3, 0.92*DOSMAX, r'$E_g= $'+str(round(gap_nscf,2))+' eV', horizontalalignment='center')

    fig = plt.gcf()
    if showgraph == 1:
      ax.show()  
    fig.savefig(PREFIX+'_PDOSdown_orbitais_m'+'.eps', format='eps', dpi=1000)
    fig.clf()
    plt.close()

    ### plot pdosup
    ax.plot(energy,pdosup,linewidth=1.0, label=element+wfcnumber+wfc)
    if wfc == 'p' :
        ax.plot(energy,pdosup_p1,linewidth=1.0, linestyle=':',label=element+wfcnumber+'$\mathregular{pz}$')
        ax.plot(energy,pdosup_p2,linewidth=1.0, linestyle='--',label=element+wfcnumber+'$\mathregular{px}$')
        ax.plot(energy,pdosup_p3,linewidth=1.0, linestyle='-.',label=element+wfcnumber+'$\mathregular{py}$')
    if wfc == 'd' :
        ax.plot(energy,pdosup_p1,linewidth=1.0,linestyle=':',label=element+wfcnumber+'$\mathregular{dz^2}$')
        ax.plot(energy,pdosup_p2,linewidth=1.0,linestyle='--',label=element+wfcnumber+'$\mathregular{dzx}$')
        ax.plot(energy,pdosup_p3,linewidth=1.0,linestyle='-.',label=element+wfcnumber+'$\mathregular{dzy}$')
        ax.plot(energy,pdosup_p4,linewidth=1.0,linestyle=':',label=element+wfcnumber+'$\mathregular{dx^2-y^2}$')
        ax.plot(energy,pdosup_p5,linewidth=1.0,linestyle='-',label=element+wfcnumber+'$\mathregular{dxy}$')
    if wfc == 'f' :
        ax.plot(energy,pdosup_p1,linewidth=1.0,linestyle=':',label=element+wfcnumber+'$\mathregular{f1}$')
        ax.plot(energy,pdosup_p2,linewidth=1.0,linestyle='--',label=element+wfcnumber+'$\mathregular{f2}$')
        ax.plot(energy,pdosup_p3,linewidth=1.0,linestyle='-.',label=element+wfcnumber+'$\mathregular{f3}$')
        ax.plot(energy,pdosup_p4,linewidth=1.0,linestyle=':',label=element+wfcnumber+'$\mathregular{f4}$')
        ax.plot(energy,pdosup_p5,linewidth=1.0,linestyle='-',label=element+wfcnumber+'$\mathregular{f5}$')
        ax.plot(energy,pdosup_p6,linewidth=1.0,linestyle='-.',label=element+wfcnumber+'$\mathregular{f6}$')
        ax.plot(energy,pdosup_p7,linewidth=1.0,linestyle='--',label=element+wfcnumber+'$\mathregular{f7}$')
    plt.title(graphtitle)
    plt.xlabel('E (eV)')
    plt.ylabel('States')


    # Shrink current axis by 20%
    box = ax.get_position()
    ax.set_position([box.x0, box.y0, box.width * 0.8, box.height])
    # Put a legend to the right of the current axis
    ax.legend(loc='center left', bbox_to_anchor=(1, 0.5))

    #plt.legend(loc='upper right')
    # plt.grid(True)
    # plt.rcParams.update({'font.size': 22})
    if min_x and max_x:
     fromx,tox=min_x,max_x 
    margin=max(dostot[(energy>min_x) & (energy<max_x)])*0.4
    ax.axis([fromx, tox, min(dostot[(energy>min_x) & (energy<max_x)])-margin, max(dostot[(energy>min_x) & (energy<max_x)]) + margin])  


    DOSMAX=max(dostot[(energy>min_x) & (energy<max_x)])
    ### FLECHA DUPLA INDICANDO BAND GAP
    if (GAP != 0) and (GAP > 1.3 ):
      ax.arrow(energy[index_topVB[0]], 0.04*DOSMAX, GAP, 0, head_width=0.6, head_length=0.5, color = 'black',  length_includes_head = True)
      ax.arrow(energy[index_botCB[0]], 0.04*DOSMAX, -GAP, 0, head_width=0.6, head_length=0.5, color = 'black',  length_includes_head = True)

      ax.text(energy[index_topVB[0]]+GAP/2, 0.14*DOSMAX, r'$E_g= $'+str(round(gap_nscf,2))+' eV', horizontalalignment='center')

    if (GAP != 0) and (GAP < 1.3 ):
      ax.arrow(energy[index_topVB[0]], 0.04*DOSMAX, GAP, 0, head_width=0.3, head_length=0.2, color = 'black',  length_includes_head = True)
      ax.arrow(energy[index_botCB[0]], 0.04*DOSMAX, -GAP, 0, head_width=0.3, head_length=0.2, color = 'black',  length_includes_head = True)

      ax.text(3, 0.92*DOSMAX, r'$E_g= $'+str(round(gap_nscf,2))+' eV', horizontalalignment='center')

    fig = plt.gcf()
    if showgraph == 1:
      ax.show()  
    fig.savefig(PREFIX+'_PDOSup_orbitais_m'+'.eps', format='eps', dpi=1000)
    fig.clf()
    plt.close()


### plotar DOStotal cada atomo
fig = plt.figure()
ax = fig.add_subplot(111)
ax.plot(energy,dostot,linewidth=1.0, label='Total DOS')
ax.fill(energy,dostot,color='0.8')

# funcao para pegar os sumpdos_ de interesse, nesse caso somente 
# os do elementos individuais
# agrupa os arquivos em pdosfiles
pdosfiles= [ ]

for file in glob.glob('sumpdos_'+PREFIX+'.*'):
    print(file)
    re_file = re.findall('sumpdos_'+PREFIX+'.[a-zA-Z]{1,}$', file)
#    print(re_file)
    if re_file != [] :
      pdosfiles.append(re_file[0])
# print(pdosfiles)


for file in pdosfiles :
  element = re.findall('sumpdos_'+PREFIX+'.([a-zA-Z]{1,})', file)[0]
  pdosdata = np.genfromtxt(file)
  pdos = pdosdata[:,1]
  if nspin == 2:
      pdosup = pdosdata[:,2]
  ax.plot(energy,pdos,linewidth=1.0, label=element[0]+wfcnumber[0]+wfc[0])
  if nspin == 2:
      ax.plot(energy,-pdosup,linewidth=1.0, label=element[0]+wfcnumber[0]+wfc[0])
plt.title(graphtitle)
plt.xlabel('E (eV)')
plt.ylabel('States')
ax.legend(loc='upper right')
# plt.grid(True)
# plt.rcParams.update({'font.size': 22})

if min_x and max_x:
 fromx,tox=min_x,max_x 
DOSMAX=max(dostot[(energy>min_x) & (energy<max_x)])
margin=DOSMAX*0.4
ax.axis([fromx, tox, -margin, DOSMAX + margin])  
if nspin == 2:
  ax.axis([fromx, tox, -DOSMAX-margin, DOSMAX + margin])  
### FLECHA DUPLA INDICANDO BAND GAP
if (GAP != 0) and (GAP > 1.3 ):
  ax.arrow(energy[index_topVB[0]], 0.04*DOSMAX, GAP, 0, head_width=0.6, head_length=0.5, color = 'black',  length_includes_head = True)
  ax.arrow(energy[index_botCB[0]], 0.04*DOSMAX, -GAP, 0, head_width=0.6, head_length=0.5, color = 'black',  length_includes_head = True)

  ax.text(energy[index_topVB[0]]+GAP/2, 0.14*DOSMAX, r'$E_g= $'+str(round(gap_nscf,2))+' eV', horizontalalignment='center')

if (GAP != 0) and (GAP < 1.3 ):
  ax.arrow(energy[index_topVB[0]], 0.04*DOSMAX, GAP, 0, head_width=0.3, head_length=0.2, color = 'black',  length_includes_head = True)
  ax.arrow(energy[index_botCB[0]], 0.04*DOSMAX, -GAP, 0, head_width=0.3, head_length=0.2, color = 'black',  length_includes_head = True)

  ax.text(3, 0.92*DOSMAX, r'$E_g= $'+str(round(gap_nscf,2))+' eV', horizontalalignment='center')

fig = plt.gcf()
if showgraph == 1:
  plt.show()
fig.savefig(PREFIX+'_PDOS_elements'+'.eps', format='eps', dpi=1000)
fig.clf()
plt.close()


EOF
python3 plotPDOS.py $INPUT


cat > plotgeral-DOS.py << 'EOF'
### edite esse arquivo com o nivel de FERMI e o nome dos arquivos para plotar
### e assim criar um grafico customizado ao seu interesse.
import numpy as np
import matplotlib.pyplot as plt
import math
import re
from matplotlib.ticker import MultipleLocator, FormatStrFormatter
#from cycler import cycler
import sys, os

FERMI=  ## geralmente disponivel no arquivo .dos
FAIXA_VB=6 ## plotar quantos eV abaixo de Fermi
FAIXA_CB=7  ## plotar quantos eV acima de Fermi


## LER DADOS DO DOS
f = np.genfromtxt('INPUT.dos')
energy = f[:,0]-FERMI
DOS = f[:,1]

### DETERMINAR A ALTURA DO PLOT
DOS_plotted=DOS[energy>-FAIXA_VB]
altura_plot= np.max(DOS_plotted)*1.4

## segundo arquivo a plotar
#f2 = np.genfromtxt('INPUT2.dos')
#energy2 = f2[:,0]-FERMI
#DOS2 = f2[:,1]

## terceiro arquivo a plotar
#f3 = np.genfromtxt('INPUT3.dos')
#energy3 = f3[:,0]-FERMI
#DOS3 = f3[:,1]

### PLOTANDO O GRAFICO ###########################################
fig = plt.figure()
ax = fig.add_subplot(111)
ax.plot(energy,DOS,label='DOS', color='blue')
#ax.plot(energy2,DOS2,label='DOS2', lw=2, color='blue')
#ax.plot(energy3,DOS3,label='DOS3', linestyle='--', color='green')

#ax.fill_between(energy,DOS,0, facecolor="lightsteelblue", label='DOS', alpha=0.4)


plt.xlabel("Energy (eV)")
plt.ylabel("DOS")
ax.axis([-FAIXA_VB, FAIXA_CB, 0, altura_plot])
#ax.axvline(x=0, color='black',linestyle='--')  ## linha do nivel de FERMI


### DEFININDO OS TICKS EM X
majorLocator   = MultipleLocator(1)
majorFormatter = FormatStrFormatter('%d')
minorLocator   = MultipleLocator(0.5)
ax.xaxis.set_major_locator(majorLocator)
ax.xaxis.set_major_formatter(majorFormatter)
ax.xaxis.set_minor_locator(minorLocator)

ax.legend(loc='upper right')

plt.show()  ### apenas mostra o plot
#plt.savefig('DOSplotado.eps', format='eps', dpi=1000)  ## para salvar um arquivo 

EOF

#################  HOMO LUMO #####################################
##  script para transformar todos os arquivos raw em cubes
##  modificar sumdensity para somar todos os cubes e obter a densidade total.
if [ "$HOMOLUMO" = 1 ] ; then 

cd PP
for i in $(ls $INPUT.HOMO_*) ; do
ID=$(echo $i | cut -f 2 -d '.' | cut -f 2- -d '_')

cat > $INPUT.HOMOcube.in << EOF
&inputpp
/
&plot
 nfile= 1,
 filepp(1)='./$INPUT.HOMO_$ID',
 weight(1)= 1.0,
 iflag= 3,
 output_format=6, 
 fileout='./$INPUT.HOMO_$ID.cube'
/
EOF

pp.x < $INPUT.HOMOcube.in 

done 

for i in $(ls $INPUT.LUMO_*) ; do
ID=$(echo $i | cut -f 2 -d '.' | cut -f 2- -d '_')

cat > $INPUT.LUMOcube.in << EOF
&inputpp
/
&plot
 nfile= 1,
 filepp(1)='./$INPUT.LUMO_$ID',
 weight(1)= 1.0,
 iflag= 3,
 output_format=6, 
 fileout='./$INPUT.LUMO_$ID.cube'
/
EOF

pp.x < $INPUT.LUMOcube.in 

done 

cat > sumdensity.py << EOF
import numpy as np
from math import ceil, floor, sqrt
 
class CUBE:
  def __init__(self, fname):
    f = open(fname, 'r')
    for i in range(2): f.readline() # echo comment
    tkns = f.readline().split() # number of atoms included in the file followed by the position of the origin of the volumetric data
    self.natoms = int(tkns[0])
    self.origin = np.array([float(tkns[1]),float(tkns[2]),float(tkns[3])])
# The next three lines give the number of voxels along each axis (x, y, z) followed by the axis vector.
    tkns = f.readline().split() #
    self.NX = int(tkns[0])
    self.X = np.array([float(tkns[1]),float(tkns[2]),float(tkns[3])])
    tkns = f.readline().split() #
    self.NY = int(tkns[0])
    self.Y = np.array([float(tkns[1]),float(tkns[2]),float(tkns[3])])
    tkns = f.readline().split() #
    self.NZ = int(tkns[0])
    self.Z = np.array([float(tkns[1]),float(tkns[2]),float(tkns[3])])
# The last section in the header is one line for each atom consisting of 5 numbers, the first is the atom number, second (?), the last three are the x,y,z coordinates of the atom center. 
    self.atoms = []
    for i in range(self.natoms):
      tkns = f.readline().split()
      self.atoms.append([tkns[0], tkns[2], tkns[3], tkns[4]])
# Volumetric data
    self.data = np.zeros((self.NX,self.NY,self.NZ))
    i=0
    for s in f:
      for v in s.split():
        self.data[i/(self.NY*self.NZ), (i/self.NZ)%self.NY, i%self.NZ] = float(v)
        i+=1
    if i != self.NX*self.NY*self.NZ: raise NameError, "FSCK!"
   
  def dump(self, f):
# output Gaussian cube into file descriptor "f". 
# Usage pattern: f=open('filename.cube'); cube.dump(f); f.close()
    print >>f, "CUBE file\ngenerated by piton _at_ erg.biophys.msu.ru"
    print >>f, "%4d %.6f %.6f %.6f" % (self.natoms, self.origin[0], self.origin[1], self.origin[2])
    print >>f, "%4d %.6f %.6f %.6f"% (self.NX, self.X[0], self.X[1], self.X[2])
    print >>f, "%4d %.6f %.6f %.6f"% (self.NY, self.Y[0], self.Y[1], self.Y[2])
    print >>f, "%4d %.6f %.6f %.6f"% (self.NZ, self.Z[0], self.Z[1], self.Z[2])
    for atom in self.atoms:
      print >>f, "%s %d %s %s %s" % (atom[0], 0, atom[1], atom[2], atom[3])
    for ix in xrange(self.NX):
      for iy in xrange(self.NY):
         for iz in xrange(self.NZ):
            print >>f, "%.5e " % self.data[ix,iy,iz],
            if (iz % 6 == 5): print >>f, ''
         print >>f,  ""
 
  def mask_sphere(self, R, Cx,Cy,Cz):
# produce spheric volume mask with radius R and center @ [Cx,Cy,Cz]
# can be used for integration over spherical part of the volume
    m=0*self.data
    for ix in xrange( int(ceil((Cx-R)/self.X[0])), int(floor((Cx+R)/self.X[0])) ):
      ryz=sqrt(R**2-(ix*self.X[0]-Cx)**2)
      for iy in xrange( int(ceil((Cy-ryz)/self.Y[1])), int(floor((Cy+ryz)/self.Y[1])) ):
          rz=sqrt(ryz**2 - (iy*self.Y[1]-Cy)**2)
          for iz in xrange( int(ceil((Cz-rz)/self.Z[2])), int(floor((Cz+rz)/self.Z[2])) ):
              m[ix,iy,iz]=1
    return m

# create an object and read in data from file 
cube=CUBE('CaMoO3.HOMO.cube')
print(cube.data[0])
f=open('filename.cube', "w+"); 
cube.dump(f); 
f.close()

# calculate total number of data points
print "Number of voxels: %d"%(cube.NX*cube.NY*cube.NZ)
# calculate box volume
print "Total volume, Angs^3: %d"%((cube.NX-1)*cube.X[0]*(cube.NY-1)*cube.Y[1]*(cube.NZ-1)*cube.Z[2])
# calculate total electron density by summing up squared values, contained in 3d array cube.data 
print "Number of electrons (sort of): %.2f"%((cube.data**2).sum()*cube.X[0]*cube.Y[1]*cube.Z[2])

EOF
cd ..
fi ## homolumo nao implementado
###############################################################


fi  ## fim do processamento com python



##################  PHONONS #####################

##################  PHONONS #####################

##################  PHONONS #####################

##################  PHONONS #####################

##################  PHONONS #####################
if [ "$calcphonons" = 1 ] ; then

####mudar o executavel usado ###
QEprog ph.x
################################

CALC=ph

PHONONS=$(ADD_MASSES $PHONONS)
MATDYN_BANDS=$(ADD_MASSES $MATDYN_BANDS)
MATDYN_DOS=$(ADD_MASSES $MATDYN_DOS)


if [ "$onlymodes" = 1 ] ; then
# self-consistent phonon calculation with ph.x
cat > $INPUT.$CALC.in << EOF
 &inputph
  prefix='$INPUT',
  outdir='$TMP_DIR'
  $PHONONS
  fildyn='dmat.$INPUT'
 /
 0.0 0.0 0.0
EOF

echo "  running the $CALC for $INPUT...\c"

tm AWS_FURG_SUBMIT

tm UFPEL_SUBMIT

tm CESUP_SUBMIT

echo "done"

CALC=dm
####mudar o executavel usado ###
QEprog dynmat.x
################################
echo " Extracting phonon data with dynmat...\c"

cat > $INPUT.$CALC.in << EOF
 &input 
 fildyn='dmat.$INPUT', 
 $DYNMAT 
 /
EOF

tm AWS_FURG_SUBMIT

tm UFPEL_SUBMIT

tm CESUP_SUBMIT

echo "done"


fi ## fim onlymodes



if [ "$phonondispersion" = 1 ] ; then


echo "  running the phonondispersion for $INPUT...\c"

cat > $INPUT.$CALC.in << EOF
 &inputph
  prefix='$INPUT',
  outdir='$TMP_DIR'
  $PHONONS
  fildyn='dmat.$INPUT'
 /
EOF

tm AWS_FURG_SUBMIT

tm UFPEL_SUBMIT

tm CESUP_SUBMIT

echo "done"


CALC=q2r
####mudar o executavel usado ###
QEprog q2r.x
################################

cat > $INPUT.$CALC.in <<EOF
 &input
   fildyn='$INPUT.dyn', 
   flfrc='$INPUT.fc',
   $Q2R
 /
EOF

echo "  transforming C(q) => C(R)...\c"

tm AWS_FURG_SUBMIT

tm UFPEL_SUBMIT

tm CESUP_SUBMIT

echo "done"


####mudar o executavel usado ###
QEprog matdyn.x
################################
if [ "$phononbands" = 1 ] ; then
CALC=matdyn_bands

cat > $INPUT.$CALC.in <<EOF
 &input
    flfrc='$INPUT.fc', flfrq='$INPUT.freq', 
    $MATDYN_BANDS
/
$MATDYN_BANDS_PATH
EOF

$ECHO "  recalculating omega(q) from C(R)...\c"

tm AWS_FURG_SUBMIT

tm UFPEL_SUBMIT

tm CESUP_SUBMIT

echo "done"
fi ## fim phonon bands

if [ "$phonondos" = 1 ] ; then
CALC=matdyn_dos
cat > $INPUT.$CALC.in <<EOF
 &input
    flfrc='$INPUT.fc', fldos='$INPUT.phdos', dos=.true.,
    $MATDYN_DOS
/
EOF

$ECHO "  calculating phonon dos...\c"

tm AWS_FURG_SUBMIT

tm UFPEL_SUBMIT

tm CESUP_SUBMIT

echo "done"
fi ## fim phonon DOS




fi  ## fim da phonondiperson

fi  ## fim calculo de phonons







if [ "$DELETAR_ARQUIVOS" = 1 ] ; then
rm -rf ./OUTPUT
fi

# do stuff in here
res2=$(date +%s.%N)
dt=$(echo "$res2 - $res1" | bc)
dd=$(echo "$dt/86400" | bc)
dt2=$(echo "$dt-86400*$dd" | bc)
dh=$(echo "$dt2/3600" | bc)
