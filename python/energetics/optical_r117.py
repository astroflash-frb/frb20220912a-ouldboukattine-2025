# A code to make Meerlicht Predictions from observed FRBs

import numpy as np
import Constants as C
import matplotlib.pylab as plt
plt.ion()


# MeerLICHT_freq = 5.172e14

MeerLICHT_freq  = 434481823.188406*1e6


t = np.logspace(-6,1,1000)*C.hr # time array [sec]

def lightcurve_calculator(t_arr, nu_obs, D, LxLr, radio_freq, t_FRB,luminosity_FRB):

    # Model inputs. Not including particle mass scaling m_*, nor f_e = n_e/n_ext such that external density is a pair plasma

    # radio_freq = 1.4e9 # 1.4 GHz
    # MeerLICHT_freq = 5.172e14  # 500nm, g-band

    # t_FRB = 0.01088 # FRB duration [seconds]
    # FRB_flux_density = 1 # FRB Flux density [Jansky]
    nu_FRB = radio_freq # FRB central frequency [Hz]
    f_maser = 1e-3 # maser efficiency [dimensionless]
    # luminosity_FRB = 8.303e41
    energy_FRB =  luminosity_FRB*t_FRB # Find a better way to write this in terms of flux, i.e. distance cancels out
    magnetization = 1e-2 # magnetization [dimensionless]
    # D = 1855400*C.kpc # distance to FRB

    # Derived properties. Not including particle mass scaling m_*, nor f_e = n_e/n_ext such that external density is a pair plasma

    E_flare = 2.5e44 * (f_maser/1e-3)**(-4/5) * (nu_FRB/600)**(1/5) * (t_FRB/1e-3)**(1/5) * (energy_FRB/1e40) # energy of the flare [erg]

    Gamma_FRB = 324 * (f_maser/1e-3)**(-1/15) * (nu_FRB/600)**(-7/30) * (t_FRB/1e-3)**(-2/5) * (energy_FRB/1e40)**(1/6) # shock LF at  frb [dimensionless]

    R_FRB = 6e12 * (f_maser/1e-3)**(-2/15) * (nu_FRB/600)**(-7/15) * (t_FRB/1e-3)**(2/5) * (energy_FRB/1e40)**(-1/3) # shock radius at  frb [cm]

    n_FRB = 124 * (f_maser/1e-3)**(-4/15) * (nu_FRB/600)**(31/30) * (t_FRB/1e-3)**(2/5) * (energy_FRB/1e40)**(-1/3) # number density media at frb [cm^-3]

    nu_syn_FRB = 228 * 2.418e20 * (magnetization/1e-2)**(1/2) * (E_flare/1e44)**(1/2) * (t_FRB/1e-3)**(3/2) # thermal electron sync freq at  frb [Hz]

    B_FRB = np.sqrt(64*np.pi*magnetization*Gamma_FRB**2 * C.mp*C.c**2*n_FRB) # shock magnetic field at  frb [Gauss]

    nu_cool_FRB = (36 * np.pi**2 * C.me * C.c * C.q)/(6.65e-25**2 * Gamma_FRB * B_FRB**2 * t_FRB)  # cooling freq at frb [Hz]

    # Calculation of lightcurves

    t_NR = t_FRB*(1.0/Gamma_FRB)**(-8.0/3.0) # time at which shock becomes non-relativistic [sec]
    print('tNR: ', t_NR)
    x = t_arr/t_NR  # dimensionless transition time

    nu_cool_NR = nu_cool_FRB*(t_NR/t_FRB)**(-5.0/4.0) # cooling freq in non-rel phase [nu]
    nu_cool = nu_cool_NR*x**(0) # cooling freq at transition [nu]
    nu_cool[x<1] = nu_cool_NR*x[x<1]**(-5.0/4.0) # cooling freq in rel phase [nu]

    R_NR = R_FRB*(t_NR/t_FRB)**(1.0/4.0) # shock radius in non-rel phase [cm]
    R = R_NR*x**(2.0/5.0) # shock radius at transition [cm]
    R[x<1] = R_NR*x[x<1]**(1.0/4.0) # shock radius in rel phase [cm]

    gamma_bar = (C.mp/C.me)*x**(-6.0/5.0) 
    gamma_bar[x<1] = (C.mp/C.me)*x[x<1]**(-3.0/8.0)


    nu_syn_NR = nu_syn_FRB*(t_NR/t_FRB)**(-3.0/2.0) # sync freq in non-rel phase [nu]
    nu_syn = nu_syn_NR*x**(-3.0) # sync freq at transition [nu]
    nu_syn[x<1] = nu_syn_NR*x[x<1]**(-3.0/2.0) # sync freq in rel phase [nu]
    print('X-ray luminosity' ,LxLr *luminosity_FRB)
    Fnu_syn_NR = LxLr * ((0.1*nu_syn_NR)**(-1)) * luminosity_FRB/(D**2)
    print('Nu_x' , nu_syn_NR)
    # Fnu_syn_NR = Fnu_syn_FRB*(t_NR)**(1/3)
    # print('new value: ',Fnu_syn_NR)

    # Fnu_syn_NR = 6.8e-7/((50*C.keV/C.h)*3e-3) # needs changing

    # print('erg s^{-1} at NR:, ', Fnu_syn_NR*nu_syn_NR*D**2)
    # print(Fnu_syn_NR)
    # Fnu_syn_NR = 6.8e-4/((57000*C.keV/C.h)*3e-3)
    Fnu_syn = Fnu_syn_NR*x**(3.0/5.0) 
    Fnu_syn[x<1] = Fnu_syn_NR
    # function to calculate expected lightcurve at nu_obs
    Fnu = Fnu_syn*(nu_obs/nu_syn)**(1.0/3.0) # optically thin thermal electron flux array
    print('dist, kpc' ,D/C.kpc)
    flt = nu_obs>nu_syn # if observing frequency is above synchrotron frequency
    Fnu[flt] = Fnu_syn[flt]*np.exp(1.0-(nu_obs/nu_syn[flt])**(1.0/3.0)) # exponential cut-of 
    Fnu_SSA = ( 2.0*np.pi*R**2*nu_obs**2*gamma_bar*C.me/3.0 )/D**2  # approximate synchrotron self-absorption limit
    # print(np.minimum( Fnu, Fnu_SSA ) )
    return np.minimum( Fnu, Fnu_SSA ) # observed lightcurve minimum of thermal electrons and absorption limit


# print(lightcurve_calculator(144e6,1e23))
t = np.logspace(-4,3,1000)*C.hr # time array [sec]



plt.figure(figsize=[8,6])

# for i in [0,1,4,6,8,9]:
#     plt.scatter((radio_limits["Time_after_burst"].iloc[i]).total_seconds()/(C.hr),radio_limits["Flux_limit"].iloc[i],label=radio_limits["Instrument"].iloc[i] + ' - ' + str(radio_limits["Freq"].iloc[i]) + ' MHz',color=color_wheel_2[i],marker="v",s=100)

# plt.loglog( t/C.hr, lightcurve_calculator(MeerKAT_freq,10)/(1e-3*C.Jy), 'orange',linewidth=3)
# Sync_flux_during_FRB = 
# Sync_flux_during_FRB = 6.8e-7/((50*C.keV/C.h)*3e-3)
# print('old value' ,Sync_flux_during_FRB)

plt.loglog(t/C.hr, lightcurve_calculator(t, MeerLICHT_freq, 362.4*1e3*C.kpc, 1e8, 1.323e9, 0.0224, 96.0e32*(1.387e9-1.259e9))/(1e-3*C.Jy),'blue',linewidth=3, label=r'B68-Wb - $F_{\rm X}/F_{\rm r} = 10^{8}$', linestyle='solid')
plt.loglog(t/C.hr, lightcurve_calculator(t, MeerLICHT_freq, 362.4*1e3*C.kpc, 1e5, 1.323e9, 0.0224, 96.0e32*(1.387e9-1.259e9))/(1e-3*C.Jy),'blue',linewidth=3, label=r'B68-Wb - $F_{\rm X}/F_{\rm r} = 10^{5}$', linestyle='dashed')

plt.loglog(t/C.hr, lightcurve_calculator(t, MeerLICHT_freq, 362.4*1e3*C.kpc, 1e8, 328e6, 0.03277, 108.71e32*(56e6))/(1e-3*C.Jy),'purple',linewidth=3, label=r'B128-Wb - $F_{\rm X}/F_{\rm r} = 10^{8}$', linestyle='solid')
plt.loglog(t/C.hr, lightcurve_calculator(t, MeerLICHT_freq, 362.4*1e3*C.kpc, 1e5, 328e6, 0.03277, 108.71e32*(56e6))/(1e-3*C.Jy),'purple',linewidth=3, label=r'B128-Wb - $F_{\rm X}/F_{\rm r} = 10^{5}$', linestyle='dashed')

# plt.loglog(t, lightcurve_calculator(t,MeerLICHT_freq,D,1e5)/(1e-3*C.Jy), 'orange',linewidth=3, label=r'$F_{\rm X}/F_{\rm r} = 10^{5}$', linestyle='solid')
# plt.loglog(t, lightcurve_calculator(t,MeerLICHT_freq,D,1e8)/(1e-3*C.Jy), 'orange',linewidth=3, label=r'$F_{\rm X}/F_{\rm r} = 10^{8}$', linestyle='dashed')
# plt.loglog(t, lightcurve_calculator(t,MeerLICHT_freq,D,1e3)/(1e-3*C.Jy), 'orange',linewidth=3, label=r'$F_{\rm X}/F_{\rm r}$ = ', linestyle='dashed')

# plt.scatter((3), 1.0957e-2,marker='v',label='3 seconds post-burst',color='darkblue')
# plt.scatter((30)+(3/60), 1.0957e-2,marker='v',label='33 seconds post-burst',color='royalblue')
# plt.scatter((60)+(3/60), 1.0957e-2,marker='v',label='63 seconds post-burst',color='cyan')

b68_atlas = [59893.324191, 18.99, 59893.327423, 19.05, 59893.334504, 19.06, 59893.345150, 19.05, 59893.434582, 18.42, 59893.437749, 18.53, 59893.445961, 18.51, 59893.462172, 18.46]
b68_times = b68_atlas[::2]
b68_mags = b68_atlas[1::2]
b68_times = [x - 59892.97580397032 for x in b68_times]
b68_times = [x*24 for x in b68_times]
print(b68_times)
b68_mJy =  1e3 * (10**(23 - ((np.array(b68_mags)+46.)/2.5)))

plt.scatter(b68_times,b68_mJy, marker='v', color='blue',label='ATLAS B68 limits')


limiting_mags = [24.5, 26.0]

limiting_mJy =  1e3 * (10**(23 - ((np.array(limiting_mags)+46.)/2.5)))

plt.hlines(limiting_mJy[0], 1e-4,1e3,color='k',label='ARCTIC band limit')
plt.hlines(limiting_mJy[1], 1e-4,1e3,color='grey',label='ARCTIC stacked limit')

# flux_rec=flux_data_rec[:,2]
# flux_err_rec=flux_data_rec[:,3]

       
plt.xlim([min(t)/C.hr,max(t)/C.hr])
plt.ylim([1e-8,1e3])

# plt.text(0.1,1e-3,'1.4 GHz',fontsize=16,color='orange')
# plt.text(0.1,1e-3,'1.4 GHz',fontsize=16,color='black')
plt.legend()
plt.tick_params(axis='both', which='major', labelsize=16)
plt.tick_params(axis='both', which='minor', labelsize=16)
plt.tick_params(direction='out', length=4, width=1, colors='k', which='both')
plt.xlabel(r'Time post burst [hr]',fontsize=16)
plt.ylabel(r'$F_\nu \,\,\,\,\, ({\rm mJy})$',fontsize=16)
plt.savefig('R117_optical_afterglow.pdf',dpi=400,bbox_inches='tight')
plt.show()