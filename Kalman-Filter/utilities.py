def kalman_predict(A, B, P_curr, Q, x_curr, u):
    '''
    :param A: modello di transizione
    :param B: control input
    :param P_curr: covarianza errore stato corrente
    :param Q: covarianza della distribuzione [N(0, Q)] che governa il rumore di transizione
    :param x_curr: stato corrente
    :param u: vettore di controllo
    :return:
            x_pred: stato predetto
            P_pred: covarianza errore predetta
    '''

    #x_k+1 = Ax_k + Bu_k
    x_pred = A * x_curr + B * u

    #P_k+1 = A P_k A_trans + Q
    P_pred = A * P_curr * A.T + Q

    return x_pred, P_pred


def kalman_correct(H, P_pred, R, z, x_pred):
    '''
    :param H: modello di osservazione che mappa x_real nella misurazione z
    :param P_pred: covarianza dell'errore predetta
    :param R: covarianza distribuzione [N(0, R)] che governa il rumore di osservazione
    :param z: misurazione del vero stato
    :param x_pred: stato predetto
    :return:
            K: Kalman gain
            x_meas: stato reale misurato
            P_real: covarianza errore reale
    '''

    # Kalman gain computation

    # S = H P_pred H_trans + R
    S = H * P_pred * H.T + R

    # K = P_pred H_trans * S_inv
    K = P_pred * H.T * S.I

    #Update

    #y = z - Hx_pred
    y = z - H*x_pred

    #x_meas = x_pred + Ky
    x_meas = x_pred + K*y

    #P_real = (I-KH)P_pred = P_pred - KHP
    P_real = P_pred - K * H * P_pred

    return K, x_meas, P_real

