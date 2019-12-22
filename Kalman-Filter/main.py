from utilities import *
import numpy as np
import matplotlib.pyplot as plt

def main():

    #modello di transizione
    A = np.matrix('1 0 1 0; 0 1 0 1; 0 0 1 0; 0 0 0 1')

    #matrice di controllo
    B = np.matrix('0.5 0; 0 0.5; 1 0; 0 1')

    # accelerazione in entrambe le direzioni
    acc_x = 1.5
    acc_y = 3

    # vettore di controllo
    u = np.matrix([acc_x, acc_y]).T

    # deviazione standard accelerazione
    std_acc_x = 60
    std_acc_y = 60

    #matrice di covarianza processo
    Q = np.matrix([[(0.5*std_acc_x)**2, 0, 0, 0],
                   [0, (0.5*std_acc_y)**2, 0, 0],
                   [0, 0, std_acc_x**2, 0],
                   [0, 0, 0, std_acc_y**2]
                   ])


    #deviazione standard posizione
    std_pos_x = 90
    std_pos_y = 90

    #matrice di covarianza osservazioni (misurazioni)
    R = np.matrix([[std_pos_x**2, 0], [0, std_pos_y**2]])


    H = np.matrix('1 0 0 0; 0 1 0 0')


    # x = (x, y, x_dot, y_dot)
    x0 = np.matrix('0 0 0 0').T
    #x_real = np.matrix('1 1 1 1').T

    x_real = np.matrix('70 120 80 160').T


    #I
    P0 = np.eye(4)

    t = list()
    real_x = list()
    real_y = list()
    real_x_dot = list()
    real_y_dot = list()

    pred_x = list()
    pred_y = list()
    pred_x_dot = list()
    pred_y_dot = list()

    meas_x = list()
    meas_y = list()
    meas_x_dot = list()
    meas_y_dot = list()

    xt = np.arange(0,35, 5)

    for i in range(0, 30):
        t.append(i)

        #rumore sulla transizione
        w = np.random.normal(0,Q)[0][0]

        #x = Ax+Bu+w
        x_real = A * x_real + B * u + w

        #Collect data
        real_x.append(x_real[0].item())
        real_y.append(x_real[1].item())
        real_x_dot.append(x_real[2].item())
        real_y_dot.append(x_real[3].item())

        #rumore di osservazione
        v = np.random.normal(0, R)[0][0]

        #z = Hx+v
        z = H * x_real + v

        #predict
        x_pred, P_pred = kalman_predict(A, B, P0, Q, x0, u)
        #update
        K, x_meas, P_real = kalman_correct(H, P_pred, R, z, x_pred)


        #Collect data
        meas_x.append(x_meas[0].item())
        meas_y.append(x_meas[1].item())
        meas_x_dot.append(x_meas[2].item())
        meas_y_dot.append(x_meas[3].item())

        pred_x.append(x_pred[0].item())
        pred_y.append(x_pred[1].item())
        pred_x_dot.append(x_pred[2].item())
        pred_y_dot.append(x_pred[3].item())

        # update parameters
        P0 = P_real
        x0 = x_meas


    #Plot results

    #x position
    real, = plt.plot(t, real_x, 'go', label = "Real")
    meas, = plt.plot(t, meas_x, 'ro', label = "Measured")
    pred, = plt.plot(t, pred_x, 'b-', label = "Predicted")
    plt.ylabel("x position")
    plt.xlabel("time")
    plt.legend(handles = [real, meas, pred])
    plt.xticks(xt)
    plt.savefig("x_pos_low_noise.pdf")
    plt.show()

    #y position
    plt.plot(t, real_y, 'go')
    plt.plot(t, meas_y, 'ro')
    plt.plot(t, pred_y, 'b-')
    plt.ylabel("y position")
    plt.xlabel("time")
    plt.legend(handles=[real, meas, pred])
    plt.xticks(xt)
    plt.savefig("y_pos.pdf")
    plt.show()

    #x velocity
    plt.plot(t, real_x_dot, 'go')
    plt.plot(t, meas_x_dot, 'ro')
    plt.plot(t, pred_x_dot, 'b-')
    plt.ylabel("x velocity")
    plt.xlabel("time")
    plt.legend(handles=[real, meas, pred])
    plt.xticks(xt)
    plt.savefig("x_vel.pdf")
    plt.show()

    #y velocity
    plt.plot(t, real_y_dot, 'go', )
    plt.plot(t, meas_y_dot, 'ro')
    plt.plot(t, pred_y_dot, 'b-')
    plt.ylabel("y velocity")
    plt.xlabel("time")
    plt.legend(handles=[real, meas, pred])
    plt.xticks(xt)
    plt.savefig("y_vel.pdf")
    plt.show()







if __name__ == "__main__":
    main()