import numpy as np
import pandas as pd


def normalise(ds, t_cent, t_sig):
    """
    Calibrate the dynamic spectrum for the bandpass
    Per frequency channel it subtracts the off burst mean and divides by the off burst std
    """
    ds=ds.copy()
    ds_off = np.concatenate((ds[:,0:int(t_cent-3*t_sig)],ds[:,int(t_cent+3*t_sig):]),axis=1)
    for chan in range(ds_off.shape[0]):
        ds[chan,:] = ds[chan,:] - np.mean(ds_off[chan,:])
        ds_off[chan,:] = ds_off[chan,:] - np.mean(ds_off[chan,:])
        if np.std(ds_off[chan,:])!=0:
            ds[chan,:] = ds[chan,:] /  np.std(ds_off[chan,:])
        else:
            ds[chan,:] = 0
    return ds

def normalize(ds,op):
    ds=ds.copy().astype(float)
    op=op.copy().astype(float)
    nds=np.zeros_like(ds)

    for chan in range(ds.shape[0]):
        channel=ds[chan,:]
        offburstchannel=op[chan,:]

        chan_mean=np.median(offburstchannel)
        chan_std=np.std(offburstchannel)
        if chan_std != 0:
            newchannel=(channel-chan_mean)/chan_std

        nds[chan,:]=newchannel

    return nds

def delta(f1, f2, DM):
    """
    Calculate the dispersive time delay in milliseconds.
    Arguments:
        f1 -- frequency of channel 1 in megahertz
        f2 -- frequency of channel 2 in megahertz. Should be greater than f1.
        DM -- dispersion measure in pc/cm^3
    Returns:
        Dispersive time delay in milliseconds between f1 and f2.
    Exceptions:
        ValueError -- if f1 > f2
    """
    if f1 > f2:
        raise ValueError('f1 must not be greater than f2')

    return (4.148808e6*(f1**(-2) - f2**(-2))*DM)

def dedisperse(data, dm, freqs, tsamp):
    """ data is a 2d numpy array
    dm is the dispersion measure in units of pc/cc
    freqs is a 1d numpy array containing the frequency per channel in units of MHz
    tsamp is the sampling time in units of seconds """
    freqs = freqs.astype(np.float64)
    reffreq = np.max(freqs)
    ndata = np.zeros_like(data)
    dmconst = 1 / (2.41 * 10**-4) # MHz^2 pc^−1 cm^3 s
    time_shift = dmconst * dm * (reffreq**-2.0 - freqs**-2.0)
    bin_shift = (time_shift / tsamp).astype(np.int32)
    assert len(bin_shift) == data.shape[0]
    assert ndata.shape == data.shape
    for i, bs in enumerate(bin_shift):
        ndata[i, :] = np.roll(data[i, :], bs)
    return ndata


def downsample(ds,tdown=1,fdown=1):
    if fdown!=1:
        ds=ds.reshape(ds.shape[0]//fdown, fdown,ds.shape[-1]).sum(axis=1)
    if tdown!=1:
        ds=ds.reshape(ds.shape[0], int(ds.shape[-1]/tdown), tdown).sum(axis=2)
    return ds
