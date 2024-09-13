#!/bin/sh


###################  INPUT GERAL QE ###########################
####  O arquivo QEscript1104.sh deve estar na mesma pasta!!! 
###############################################################

######### PARA EXECUTAR USE QEscriptXXXX.sh  ############
######### ./QEscriptXXXX.sh &

################# QUAL SERVIDOR VAMOS USAR? ###################
###############################################################
#SERVER=UFPEL
#SERVER=FURG
SERVER=CESUP; CLUSTER=FERMI  ### CLUSTERS: GAUSS, NEWTON, FERMI
###############################################################

### QUANTOS PROCESSADORES ESSE CALCULO IRA REQUERER? ##########
###############################################################
NP=24    ## OMPNP * MPINP
### somente se estiver rodando do CESUP-FERMI ou CESUP-NEWTON  ####
NODES=2     ### numero de nos selecionado
OMPNP=1     ### numero de processos de memoria compartilhada
MPINP=24     ### numero de processos mpi
MEMORY="92GB"     ### memoria requerida
### SE O CLUSTER FOR FERMI, CALCULAR COM GPU? Somente pw.x ativido ##
fermiGPU=1
fermiLOCAL=0
###############################################################

### O CALCULO USARA FLAGS DE PARALELIZACAO ?  ##################
### SE SIM, ADICIONE ABAIXO AS FLAGS   #########################
PARALLELFLAGS=" "
###Ex: " -nk 2 -ntg 2 -ndiag 9 "
################################################################

######  PREFIXO DO CALCULO E USUARIO ##########################
###############################################################
INPUT=CsSbIt-In   ### identificacao dos seus arquivos de calculo
USUARIO=raglamai    #### se usar o CESUP use mesmo nome de usuario
###############################################################

###### ARQUIVOS DE SAIDA SERAO DELETADOS APOS OS CALCULOS ? ####
###### Arquivos da pasta OUTDIR ################################
DELETAR_ARQUIVOS="0"
################################################################

### QUE CALCULOS SERÃO REALIZADOS? #############################
################################################################
##### 1 para o que deseja calcular     #########################
##### 0 para o que nao deseja calcular #########################
################################################################

##### calculo de relaxacao  ####################################
calcrelax=0   ### se estiver precedendo um calculo de convergencia use cutoffs altos.
 gammapoint=0  ## relaxacao com ponto gamma.
   kgridrelax=1    ## relaxacao com kgrid somente para casos de dificil convergencia.
   kptgrid_relax=(4 4 2)
fixcell=0
################################################################

##### teste de convergencia energia e kgrid ####################
##### se ativou calcrelax tambem vai usar a estrutura previamente relaxada
calc_conv=0  ### calculo de convergencia energia e pontos k
    PPtype=0  ## 0 for NCPP, 1 for USPP and 2 for PAW.
    ### qual o range e o passo para testar o cutoff de energia
    ecutwfc_min=80 ; ecutwfc_max=120  ; ecutwfc_step=10 
    ### cutoff testado com gamma somente (preferivel)
    cutoff_with_gamma=0   ### se quiser testar o cutoff com mais pontos k, somente casos dificil convergencia
    kpt_cutoff=(3 3 2)  ### somente se cutoff_with_gamma=0 
    ### vai estimar os k sampling em cada direcao a partir das razoes de parametro de rede
    parameters_ratio=(1 1 2.48 )   ## (a/a b/a c/a)
    kpts_max=6   ## maximo de pontos no parametro reciproco de a
    ecutwfc_kpts=120 ### ecutwfc para teste com kpoints
    thresold_energydiff=0.01 ## in eV para definir se convergido
################################################################

##### teste hubbard - screening para valores de U ##############
calc_hubbardU=0
 kptgrid=(4 4 3)
 kptgrid_nscf=(4 4 3)
    number_hubbard_sites=1   ### ate 3 elementos ao mesmo tempo
 hubbardU1_min=0.001   ### valor minimo para primeiro elemento
 hubbardU1_max=0.501   ### valor maximo para primeiro elemento
 stepU1=0.5            ### passo de variacao do valor de U
 hubbardU2_min=0.001
 hubbardU2_max=5.001
 stepU2=0.5
 hubbardU3_min=0.001
 hubbardU3_max=5.001
 stepU3=0.5
################################################################

##### calculo eletronico - scf  ################################
calcscf=0
 kptgrid=(4 4 2)  ## certifique-se da convergencia
gridshift_scf=1
################################################################

##### calculo eletronico para DOS - nscf #######################
calcnscf=1
 kptgrid_nscf=(6 6 3)  ## pode aumentar em rel. ao scf
gridshift_nscf=0

################################################################

##### calculo eletronico para bandas - bands ###################
calcbands=0
################################################################

##### pos processamento - gerar densidades, dos e etc  #########
calcPP=1
################################################################

##### calculo de carga por analise de bader ####################
calcbader=1    ## precisa ter gerado o .cube no PP
 bader_path="./bader"  ## caminho para o executavel da analise de bader
################################################################

##### pos processamento  dos dados ##################
PPpython=1
#####################################################

##### calculo de phonons #########################
calcphonons=0
 onlymodes=1
 phonondispersion=1
################################################################


######### OUTRAS CUSTOMIZACOES ##################################
######  se voce quer definir o diretorio dos pseudopotenciais manualmente ####
define_pseudodir=0
 PSEUDO_DIR="/home/u/rogerio/pseudo/pseudodojo-fr" 
define_outdir=0
    TMP_DIR="./OUTPUT"
###############################################################
###############################################################


######################## FICHAS ###################
### if you need extra commmands on CONTROL.
CONTROL="
verbosity = 'high',
"

SYSTEM="
&SYSTEM
 ibrav=0, nat=28, ntyp= 4,
  occupations = 'smearing', smearing='gauss',  degauss = 0.0002,
  nspin = 2
  starting_magnetization(1)=0.3
  ecutwfc = 50.0
  ecutrho= 300
/
"

ELECTRONS="
&ELECTRONS
 mixing_mode='local-TF'
 diagonalization='david',
 conv_thr =  1.0d-8,
 mixing_beta = 0.5,
 electron_maxstep = 300
 startingwfc='random',
/"

ATOMIC_SPECIES="
ATOMIC_SPECIES
  Sb 65.409  sb.gbrv_us.upf
  Cs  132.91 cs.gbrv_us.upf
   I 121.76  i.gbrv_us.upf
  In 1  in.gbrv_us.upf
"

#CELL_PARAMETERS (angstrom)
# 6.807604144 3.930372085  0.000000000
#-6.807604144 3.930372085  0.000000000
# 0.000000000 0.000000000  9.569567198
CELL_AND_ATOMS="
CELL_PARAMETERS (angstrom)
   8.621762452  -0.000000000  -0.000000000
  -4.310881226   7.466665309  -0.000000000
   0.000000000   0.000000000  21.246215018

ATOMIC_POSITIONS (angstrom)
Cs           -0.0000000000       -0.0000000000        0.0000000000
Cs            0.0000000000        0.0000000000       10.6231075092
Cs            0.0000000000        4.9777767638        3.4351744845
Cs            0.0000000000        4.9777767638       14.0582663386
Cs            4.3108812261        2.4888883819        7.1879486798
Cs            4.3108812261        2.4888883819       17.8110398206
Sb            0.0000000000        4.9777767638        8.6404555480
Sb            0.0000000000        4.9777767638       19.2635252719
Sb            4.3108812261        2.4888883819        1.9826904599
In            4.3108812261        2.4888883819       12.6057585185
I            -2.1554406131        3.7333325733        0.0000000000
I            -2.1554406131        3.7333325733       10.6231075092
I             4.3108812261       -0.0000000000        0.0000000000
I             4.3108812261       -0.0000000000       10.6231075092
I             2.1554406131        3.7333325733        0.0000000000
I             2.1554406131        3.7333325733       10.6231075092
I            -2.1279038978        6.2063224190        7.0572836286
I            -2.1278860436        6.2063121108       17.6803057515
I             2.1279041358        6.2063224190        7.0572836286
I             2.1278862816        6.2063121108       17.6803057515
I             0.0000000000        2.5206849785        7.0572836286
I             0.0000000000        2.5207055948       17.6803057515
I             6.4387672698        1.2603527979        3.5659090284
I             6.4387851240        1.2603424898       14.1889313898
I             2.1829951815        1.2603527979        3.5659090284
I             2.1829773273        1.2603424898       14.1889313898
I             4.3108812261        4.9459600258        3.5659090284
I             4.3108812261        4.9459806420       14.1889313898
"


if [ "$calcrelax" = 1 ] ; then

CELL="&CELL 
! cell_dofree='xyz',
/
"

IONS="&IONS
!ion_dynamics = 'bfgs',
!  upscale = 1000,
!  bfgs_ndim = 2,
!trust_radius_ini = 0.188,
!trust_radius_max = 0.188,   ! aprox 0.1A
/"

fi

if [ "$calcbands" = 1 ] ; then
BANDS="
K_POINTS crystal
106
    0.0000000000     0.0000000000     0.0000000000 1
    0.0312500000     0.0000000000     0.0000000000 1
    0.0625000000     0.0000000000     0.0000000000 1
    0.0937500000     0.0000000000     0.0000000000 1
    0.1250000000     0.0000000000     0.0000000000 1
    0.1562500000     0.0000000000     0.0000000000 1
    0.1875000000     0.0000000000     0.0000000000 1
    0.2187500000     0.0000000000     0.0000000000 1
    0.2500000000     0.0000000000     0.0000000000 1
    0.2812500000     0.0000000000     0.0000000000 1
    0.3125000000     0.0000000000     0.0000000000 1
    0.3437500000     0.0000000000     0.0000000000 1
    0.3750000000     0.0000000000     0.0000000000 1
    0.4062500000     0.0000000000     0.0000000000 1
    0.4375000000     0.0000000000     0.0000000000 1
    0.4687500000     0.0000000000     0.0000000000 1
    0.5000000000     0.0000000000     0.0000000000 1
    0.4814814815     0.0370370370     0.0000000000 1
    0.4629629630     0.0740740741     0.0000000000 1
    0.4444444444     0.1111111111     0.0000000000 1
    0.4259259259     0.1481481481     0.0000000000 1
    0.4074074074     0.1851851852     0.0000000000 1
    0.3888888889     0.2222222222     0.0000000000 1
    0.3703703704     0.2592592593     0.0000000000 1
    0.3518518519     0.2962962963     0.0000000000 1
    0.3333333333     0.3333333333     0.0000000000 1
    0.3157894737     0.3157894737     0.0000000000 1
    0.2982456140     0.2982456140     0.0000000000 1
    0.2807017544     0.2807017544     0.0000000000 1
    0.2631578947     0.2631578947     0.0000000000 1
    0.2456140351     0.2456140351     0.0000000000 1
    0.2280701754     0.2280701754     0.0000000000 1
    0.2105263158     0.2105263158     0.0000000000 1
    0.1929824561     0.1929824561     0.0000000000 1
    0.1754385965     0.1754385965     0.0000000000 1
    0.1578947368     0.1578947368     0.0000000000 1
    0.1403508772     0.1403508772     0.0000000000 1
    0.1228070175     0.1228070175     0.0000000000 1
    0.1052631579     0.1052631579     0.0000000000 1
    0.0877192982     0.0877192982     0.0000000000 1
    0.0701754386     0.0701754386     0.0000000000 1
    0.0526315789     0.0526315789     0.0000000000 1
    0.0350877193     0.0350877193     0.0000000000 1
    0.0175438596     0.0175438596     0.0000000000 1
    0.0000000000     0.0000000000     0.0000000000 1
    0.0000000000     0.0000000000     0.1000000000 1
    0.0000000000     0.0000000000     0.2000000000 1
    0.0000000000     0.0000000000     0.3000000000 1
    0.0000000000     0.0000000000     0.4000000000 1
    0.0000000000     0.0000000000     0.5000000000 1
    0.0312500000     0.0000000000     0.5000000000 1
    0.0625000000     0.0000000000     0.5000000000 1
    0.0937500000     0.0000000000     0.5000000000 1
    0.1250000000     0.0000000000     0.5000000000 1
    0.1562500000     0.0000000000     0.5000000000 1
    0.1875000000     0.0000000000     0.5000000000 1
    0.2187500000     0.0000000000     0.5000000000 1
    0.2500000000     0.0000000000     0.5000000000 1
    0.2812500000     0.0000000000     0.5000000000 1
    0.3125000000     0.0000000000     0.5000000000 1
    0.3437500000     0.0000000000     0.5000000000 1
    0.3750000000     0.0000000000     0.5000000000 1
    0.4062500000     0.0000000000     0.5000000000 1
    0.4375000000     0.0000000000     0.5000000000 1
    0.4687500000     0.0000000000     0.5000000000 1
    0.5000000000     0.0000000000     0.5000000000 1
    0.4814814815     0.0370370370     0.5000000000 1
    0.4629629630     0.0740740741     0.5000000000 1
    0.4444444444     0.1111111111     0.5000000000 1
    0.4259259259     0.1481481481     0.5000000000 1
    0.4074074074     0.1851851852     0.5000000000 1
    0.3888888889     0.2222222222     0.5000000000 1
    0.3703703704     0.2592592593     0.5000000000 1
    0.3518518519     0.2962962963     0.5000000000 1
    0.3333333333     0.3333333333     0.5000000000 1
    0.3157894737     0.3157894737     0.5000000000 1
    0.2982456140     0.2982456140     0.5000000000 1
    0.2807017544     0.2807017544     0.5000000000 1
    0.2631578947     0.2631578947     0.5000000000 1
    0.2456140351     0.2456140351     0.5000000000 1
    0.2280701754     0.2280701754     0.5000000000 1
    0.2105263158     0.2105263158     0.5000000000 1
    0.1929824561     0.1929824561     0.5000000000 1
    0.1754385965     0.1754385965     0.5000000000 1
    0.1578947368     0.1578947368     0.5000000000 1
    0.1403508772     0.1403508772     0.5000000000 1
    0.1228070175     0.1228070175     0.5000000000 1
    0.1052631579     0.1052631579     0.5000000000 1
    0.0877192982     0.0877192982     0.5000000000 1
    0.0701754386     0.0701754386     0.5000000000 1
    0.0526315789     0.0526315789     0.5000000000 1
    0.0350877193     0.0350877193     0.5000000000 1
    0.0175438596     0.0175438596     0.5000000000 1
    0.0000000000     0.0000000000     0.5000000000 1
    0.5000000000     0.0000000000     0.5000000000 1
    0.5000000000     0.0000000000     0.4000000000 1
    0.5000000000     0.0000000000     0.3000000000 1
    0.5000000000     0.0000000000     0.2000000000 1
    0.5000000000     0.0000000000     0.1000000000 1
    0.5000000000     0.0000000000     0.0000000000 1
    0.3333333333     0.3333333333     0.5000000000 1
    0.3333333333     0.3333333333     0.4000000000 1
    0.3333333333     0.3333333333     0.3000000000 1
    0.3333333333     0.3333333333     0.2000000000 1
    0.3333333333     0.3333333333     0.1000000000 1
    0.3333333333     0.3333333333     0.0000000000 1
"
## estrutura de bandas do problema
fi

if [ "$calcphonons" = 1 ] ; then
## se for fazer calculo de phonons 
## massas, entrada e saida sao especificados automaticamente
## https://www.quantum-espresso.org/Doc/INPUT_PH.html#idm105

PHONONS="
  tr2_ph=1.0d-14,  ! thresold for self consistency less than d-12
  epsil=.false., ! true only for non metals
  trans=.true.,   ! compute phonons
  asr=.true.,  ! acoustic sum rule   
"
### para extrair os dados da matriz dinamica dos phonons
### especifique as variaveis menos fildyn que e automaticamente inserido.
### https://www.quantum-espresso.org/Doc/INPUT_DYNMAT.html#idm12
DYNMAT="
asr='zero-dim'
"

####https://www.quantum-espresso.org/Doc/ph_user_guide.pdf
#### HEADER do arquivo PHonon/PH/q2r.f90.
Q2R="
zasr='simple',
"
#### HEADER do arquivo PHonon/PH/matdyn.f90
MATDYN="
asr='simple',
q_in_band_form=.true.,
"

MATDYN_DOS="
    asr='simple',  
    nk1=6, nk2=6, nk3=6
"
    
MATDYN_BANDS_PATH="
 6
  gG    40
  X     20
  W     20
  1.0   1.0 0.0   40
  gG    40
  L     1
"
fi 

########################## FIM DAS FICHAS ####################
#############################################################

######### PARA EXECUTAR USE QEscriptXXXX.sh  ############
######### ./QEscriptXXXX.sh &
