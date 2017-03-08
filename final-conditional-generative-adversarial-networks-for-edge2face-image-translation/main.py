import argparse
import os
import numpy as np
import tensorflow as tf

from model import edge2face

parser = argparse.ArgumentParser(description='')

parser.add_argument('--phase', dest='phase', default='train', help='train, test')

args = parser.parse_args()

def main(_):
    with tf.Session() as sess:
        model = edge2face(sess)

        if args.phase == 'train':
            model.train()
        else:
            model.test()

if __name__ == '__main__':
    tf.app.run()
