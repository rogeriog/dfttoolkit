#!/bin/sh
###################  INPUT GERAL QE ###########################
####  O arquivo QEscript1102.sh deve estar na mesma pasta!!! 
###############################################################

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
fermiGPU=0
### SE O CLUSTER FOR O FERMI, PARA USAR A VERSAO LOCAL COM CORRECOES PARA CALCULAR DFT+U
fermiLOCAL=1
###############################################################

### O CALCULO USARA FLAGS DE PARALELIZACAO ?  ##################
### SE SIM, ADICIONE ABAIXO AS FLAGS   #########################
PARALLELFLAGS="  "
###Ex: " -nk 2 -nb 2 "
################################################################

######  PREFIXO DO CALCULO E USUARIO ##########################
###############################################################
INPUT=CSBrNC_4Cls   ### identificacao dos seus arquivos de calculo
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
calcrelax=1  ### se estiver precedendo um calculo de convergencia use cutoffs altos.
 gammapoint=1  ## relaxacao com ponto gamma.
   kgridrelax=0    ## relaxacao com kgrid somente para casos de dificil convergencia.
   kptgrid_relax=(5 5 5)
 fixcell=1
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
 kptgrid=(1 1 1)  ## certifique-se da convergencia
gridshift_scf=0
################################################################

##### calculo eletronico para DOS - nscf #######################
calcnscf=0
 kptgrid_nscf=(1 1 1)  ## pode aumentar em rel. ao scf
gridshift_nscf=0

################################################################

##### calculo eletronico para bandas - bands ###################
calcbands=0
################################################################

##### pos processamento - gerar densidades, dos e etc  #########
calcPP=0
################################################################

##### calculo de carga por analise de bader ####################
calcbader=0   ## precisa ter gerado o .cube no PP
 bader_path="./bader"  ## caminho para o executavel da analise de bader
################################################################

##### pos processamento  dos dados ##################
PPpython=0
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
 ibrav=8, nat=73, ntyp= 4,
 A = 25, B=25, C=25 

! occupations = 'tetrahedra_opt'
 occupations = 'smearing',  smearing='gauss',  degauss = 0.02,
! nspin = 2
 ! lda_plus_u=.true.,  
 ! Hubbard_U(2)=2.5,
 ! Hubbard_U(4)=4,  
! starting_magnetization(2)=0.1
 ecutwfc = 50.0
 ecutrho = 300
/
"

ELECTRONS="
&ELECTRONS
!  diagonalization = 'cg',
  mixing_mode='local-TF'
  mixing_beta = 0.1,
  mixing_ndim = 4, 
! startingwfc='random',
! conv_thr =  1.0d-8,
  electron_maxstep = 500,
/"

ATOMIC_SPECIES="
ATOMIC_SPECIES
  Sb 65.409  sb.gbrv_us.upf
  Br 79.904  br.gbrv_us.upf
  Cs  132.91 cs.gbrv_us.upf
  Cl 79.904  cl.gbrv_us.upf

"
CELL_AND_ATOMS="
ATOMIC_POSITIONS (angstrom)
Br  7.47201 12.28281  10.19076
Br  7.49847 12.27591  20.11004
Br  15.62655  12.27242  10.18867
Br  15.62933  12.27086  20.11558
Br  11.54254  19.32723  10.19061
Br  11.55861  19.31 20.1102
Br  9.43174 8.89112 10.19015
Br  9.43874 8.91411 20.11023
Br  17.56823  8.89112 10.19022
Br  17.56142  8.91411 20.1103
Br  13.49998  15.95498  10.18838
Br  13.50007  15.9586 20.11567
Br  11.37332  12.27237  10.18864
Br  11.37064  12.27075  20.1156
Br  19.52786  12.28275  10.19087
Br  19.5015 12.27581  20.11021
Br  15.45731  19.32717  10.19064
Br  15.44135  19.3099 20.1103
Br  15.44139  7.69  6.88979
Br  15.45746  7.67277 16.80939
Br  11.37067  14.72914  6.88442
Br  11.37345  14.72758  16.81133
Br  19.50153  14.7241 6.88996
Br  19.52799  14.7172 16.80924
Br  13.49993  11.04141  6.88433
Br  13.50002  11.04502  16.81162
Br  9.43858 18.0859 6.8897
Br  9.43177 18.10889  16.80978
Br  17.56126  18.0859 6.88977
Br  17.56826  18.10889  16.80985
Br  11.55865  7.6901  6.8897
Br  11.54269  7.67283 16.80936
Br  7.4985  14.7242 6.88979
Br  7.47214 14.71725  16.80913
Br  15.62936  14.72925  6.8844
Br  15.62668  14.72764  16.81136
Br  11.46056  9.96872 13.49975
Cl  7.38954 17.02446  13.49382
Br  19.61047  9.97555 13.50618
Br  15.53944  17.03128  13.50025
Cl  13.5  6.4486  13.4957
Br  9.42013 13.5  13.49997
Br  17.57987  13.5  13.50003
Cl  13.5  20.5514 13.5043
Br  7.38953 9.97554 13.50609
Br  15.53944  9.96872 13.49978
Br  11.46055  17.03128  13.50022
Cl  19.61047  17.02447  13.49391
Sb  13.50003  8.77682 15.32773
Sb  9.41392 15.86164  15.32799
Sb  17.58612  15.86163  15.32808
Sb  9.41389 11.13837  11.67192
Sb  17.58608  11.13837  11.67201
Sb  13.49997  18.22318  11.67227
Cs  13.5001 8.80505 10.24405
Cs  13.50019  8.82143 20.19484
Cs  9.435 15.84751  10.24349
Cs  9.4495  15.83853  20.19488
Cs  17.56518  15.84751  10.24356
Cs  17.55087  15.83853  20.19495
Cs  9.44913 11.16148  6.80505
Cs  9.43482 11.1525 16.75644
Cs  17.5505 11.16148  6.80512
Cs  17.565  11.15249  16.75651
Cs  13.49981  18.17857  6.80516
Cs  13.4999 18.19495  16.75595
Cs  9.45193 6.49228 13.49991
Cs  5.44592 13.5  13.49992
Cs  17.54807  6.49229 13.49999
Cs  13.5  13.5  13.5
Cs  9.45193 20.50771  13.50001
Cs  21.55408  13.5  13.50008
Cs  17.54807  20.50772  13.50009
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
## estrutura de bandas do problema
BANDS="
K_POINTS crystal_b
13
   0.0000000000     0.0000000000     0.0000000000     10
   0.6666666667    -0.3333333333     0.0000000000     10
   0.3333333333     0.3333333333     0.0000000000     10
   0.0000000000     0.5000000000     0.0000000000     10
   0.0000000000     0.0000000000     0.0000000000     10
   0.0000000000     0.5000000000     0.5000000000     10
   0.3333333333     0.3333333333     0.5000000000     10
   0.6666666667    -0.3333333333     0.5000000000     10
   0.0000000000     0.0000000000     0.5000000000     10
   0.0000000000     0.0000000000     0.0000000000     10
   0.5000000000     0.0000000000     0.5000000000     10
   0.0000000000     0.0000000000     0.0000000000     10
   0.5000000000     0.0000000000     0.0000000000     10
"
fi


########################## FIM DAS FICHAS ####################
#############################################################





### linha de execucao
#./QEscriptXXXX.sh &



