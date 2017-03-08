import os
import time
import numpy as np
import tensorflow as tf

from glob import glob
from data_utils import *
from activations import *

class edge2face(object):
    def __init__(self, sess):

        self.sess = sess
        self.image_size = 256
        self.image_channel = 1
        self.batch_size = 1
        self.epoch = 15

        self.dataset_dirname = './datasets'
        self.model_dirname = './model'
        self.model_name = 'edge2face'

        # define batch normalization layers for discriminator and generator for later usage.
        self.d_bn1 = batch_norm(name='d_bn1')
        self.d_bn2 = batch_norm(name='d_bn2')
        self.d_bn3 = batch_norm(name='d_bn3')

        self.g_bn_e2 = batch_norm(name='g_bn_e2')
        self.g_bn_e3 = batch_norm(name='g_bn_e3')
        self.g_bn_e4 = batch_norm(name='g_bn_e4')
        self.g_bn_e5 = batch_norm(name='g_bn_e5')
        self.g_bn_e6 = batch_norm(name='g_bn_e6')
        self.g_bn_e7 = batch_norm(name='g_bn_e7')
        self.g_bn_e8 = batch_norm(name='g_bn_e8')

        self.g_bn_d1 = batch_norm(name='g_bn_d1')
        self.g_bn_d2 = batch_norm(name='g_bn_d2')
        self.g_bn_d3 = batch_norm(name='g_bn_d3')
        self.g_bn_d4 = batch_norm(name='g_bn_d4')
        self.g_bn_d5 = batch_norm(name='g_bn_d5')
        self.g_bn_d6 = batch_norm(name='g_bn_d6')
        self.g_bn_d7 = batch_norm(name='g_bn_d7')

        # start building computational graph
        self.build_model()

    def build_model(self):
        print '[*] Building GANs...'

        self.real_data = tf.placeholder(dtype=tf.float32,
                                        shape=(self.batch_size, self.image_size, self.image_size, 2*self.image_channel),
                                        name='real_A_and_B_images')

        self.real_B = self.real_data[:, :, :, 0:self.image_channel]
        self.real_A = self.real_data[:, :, :, self.image_channel:2*self.image_channel]

        self.fake_B = self.generator(self.real_A)

        # concatenate A, B image in channel dimension
        self.real_AB = tf.concat(3, [self.real_A, self.real_B])
        self.fake_AB = tf.concat(3, [self.real_A, self.fake_B])

        self.D, self.D_logits = self.discriminator(self.real_AB, reuse=False)
        # calling discriminator again, need to specify reusing variables in discriminator
        self.D_, self.D_logits_ = self.discriminator(self.fake_AB, reuse=True)

        # define discriminator objective: argmax{ E[log D(real_AB)] + E[log 1-D(fake_AB)] }
        self.d_loss_real = tf.reduce_mean(tf.nn.sigmoid_cross_entropy_with_logits(self.D_logits, tf.ones_like(self.D)))
        self.d_loss_fake = tf.reduce_mean(tf.nn.sigmoid_cross_entropy_with_logits(self.D_logits_, tf.zeros_like(self.D_)))
        self.d_loss = self.d_loss_real + self.d_loss_fake

        # define generator objective: argmin{ E[log 1-D(fake_AB)] + lambda * L1_norm(real_B, fake_B) }
        self.L1_lambda = 100.0
        self.g_loss = tf.reduce_mean(tf.nn.sigmoid_cross_entropy_with_logits(self.D_logits_, tf.ones_like(self.D_))) \
                        + self.L1_lambda * tf.reduce_mean(tf.abs(self.real_B - self.fake_B))

        # get trainable parameters of discriminator and generator
        self.d_vars = [var for var in tf.trainable_variables() if 'd_' in var.name]
        self.g_vars = [var for var in tf.trainable_variables() if 'g_' in var.name]

        self.saver = tf.train.Saver()

    def discriminator(self, image, reuse=False):
        print '[*] Building discriminator...'

        if reuse:
            tf.get_variable_scope().reuse_variables()
        else:
            assert tf.get_variable_scope().reuse == False

        h0 = lrelu(conv2d(image, 64, name='d_h0_conv'))
        h1 = lrelu(self.d_bn1(conv2d(h0, 128, name='d_h1_conv')))
        h2 = lrelu(self.d_bn2(conv2d(h1, 256, name='d_h2_conv')))
        h3 = lrelu(self.d_bn3(conv2d(h2, 512, stride_height=1, stride_width=1, name='d_h3_conv')))
        h4 = linear(tf.reshape(h3, [self.batch_size, -1]), 1, 'd_h3_lin')

        return sigmoid(h4), h4

    def generator(self, image):
        print '[*] Building generator...'

        # encoder
        e1 = conv2d(image, 64, name='g_e1_conv')
        e2 = self.g_bn_e2(conv2d(lrelu(e1), 128, name='g_e2_conv'))
        e3 = self.g_bn_e3(conv2d(lrelu(e2), 256, name='g_e3_conv'))
        e4 = self.g_bn_e4(conv2d(lrelu(e3), 512, name='g_e4_conv'))
        e5 = self.g_bn_e5(conv2d(lrelu(e4), 512, name='g_e5_conv'))
        e6 = self.g_bn_e6(conv2d(lrelu(e5), 512, name='g_e6_conv'))
        e7 = self.g_bn_e7(conv2d(lrelu(e6), 512, name='g_e7_conv'))
        e8 = self.g_bn_e8(conv2d(lrelu(e7), 512, name='g_e8_conv'))

        # decoder
        d1 = deconv2d(relu(e8), [self.batch_size, 2, 2, 512], name='g_d1')
        d1 = dropout(self.g_bn_d1(d1))
        d1 = tf.concat(3, [d1, e7])

        d2 = deconv2d(relu(d1), [self.batch_size, 4, 4, 512], name='g_d2')
        d2 = dropout(self.g_bn_d2(d2))
        d2 = tf.concat(3, [d2, e6])

        d3 = deconv2d(relu(d2), [self.batch_size, 8, 8, 512], name='g_d3')
        d3 = dropout(self.g_bn_d3(d3))
        d3 = tf.concat(3, [d3, e5])

        d4 = deconv2d(relu(d3), [self.batch_size, 16, 16, 512], name='g_d4')
        d4 = self.g_bn_d4(d4)
        d4 = tf.concat(3, [d4, e4])

        d5 = deconv2d(relu(d4), [self.batch_size, 32, 32, 256], name='g_d5')
        d5 = self.g_bn_d5(d5)
        d5 = tf.concat(3, [d5, e3])

        d6 = deconv2d(relu(d5), [self.batch_size, 64, 64, 128], name='g_d6')
        d6 = self.g_bn_d6(d6)
        d6 = tf.concat(3, [d6, e2])

        d7 = deconv2d(relu(d6), [self.batch_size, 128, 128, 64], name='g_d7')
        d7 = self.g_bn_d7(d7)
        d7 = tf.concat(3, [d7, e1])

        d8 = deconv2d(relu(d7), [self.batch_size, 256, 256, 1], name='g_d8')

        return tanh(d8)

    def load_model(self):
        print '[*] Loading model...'

        ckpt = tf.train.get_checkpoint_state(self.model_dirname)
        if ckpt and ckpt.model_checkpoint_path:
            model_name = os.path.basename(ckpt.model_checkpoint_path)
            self.saver.restore(self.sess, os.path.join(self.model_dirname, model_name))
            return True
        else:
            return False

    def save_model(self, step):
        print '[*] Saving model...'

        if not os.path.exists(self.model_dirname):
            print '[*] Creating {} folder for saving model...'.format(self.model_dirname)
            os.makedirs(self.model_dirname)

        self.saver.save(self.sess, os.path.join(self.model_dirname, self.model_name), global_step=step)

    def train(self):
        print '[*] Prepare to train...'

        # define optimizers for discriminator and generator
        self.d_optim = tf.train.AdamOptimizer(learning_rate=0.0002, beta1=0.5) \
                        .minimize(self.d_loss, var_list=self.d_vars)
        self.g_optim = tf.train.AdamOptimizer(learning_rate=0.0002, beta1=0.5) \
                        .minimize(self.g_loss, var_list=self.g_vars)

        tf.global_variables_initializer().run()

        step = 1
        start_time = time.time()

        # restore model
        if self.load_model():
            print '[*] Succeed to load model'
        else:
            print '[!] Failed to load model'

        for epoch in xrange(self.epoch):
            image_paths = glob('{}/train/*'.format(self.dataset_dirname))
            batch_indexs = len(image_paths) / self.batch_size

            # train on batch
            for index in xrange(batch_indexs):

                # list of batch_size image paths
                batch_image_paths = image_paths[index*self.batch_size:(index+1)*self.batch_size]

                # batch_images shape=(batch_size, height, width, image_channel*2)
                batch_images = np.array([load_data(image_path) for image_path in batch_image_paths]).astype(np.float32)

                # run the discriminator operation to update discriminator parameters
                print '[*] Updating discriminator parameters...'
                self.sess.run(self.d_optim, feed_dict={ self.real_data: batch_images })

                # run the generator operation to update generator parameters
                # update twice for preventing discriminator from converging too quicky
                print '[*] Updating generator parameters...'
                self.sess.run(self.g_optim, feed_dict={ self.real_data: batch_images })
                self.sess.run(self.g_optim, feed_dict={ self.real_data: batch_images })

                # compute loss for logging
                print '[*] Computing loss...'
                d_loss = self.d_loss.eval({ self.real_data: batch_images })
                g_loss = self.g_loss.eval({ self.real_data: batch_images })

                print '===| Epoch: [%d/%d] | Index: [%d/%d] | Time: %4.4f | d_loss: %.8f | g_loss: %.8f |===' \
                    % (epoch, self.epoch, index, batch_indexs, time.time() - start_time, d_loss, g_loss)

                # for every 5 steps, save model
                step += 1
                if np.mod(step, 5) == 1:
                    self.save_model(step)

    def test(self):
        print '[*] Prepare to test...'

        tf.global_variables_initializer().run()

        # list of batch_size image paths
        sample_files = glob('{}/input/*'.format(self.dataset_dirname))
        sample_files = sorted(sample_files, key=lambda path: int(path.split('/')[-1].split('.')[0]))

        print '[*] Loading testing images...'

        # shape=(batch_size, height, width, image_channel*2)
        sample = [load_data(sample_file) for sample_file in sample_files]

        sample_images = np.array(sample).astype(np.float32)

        sample_images = [sample_images[i:i+self.batch_size]
                         for i in xrange(0, len(sample_images), self.batch_size)]

        # convert list of 4D tensor to 5D tensor
        # shape=(batch_groups, batch_size, height, width, image_channel*2)
        sample_images = np.array(sample_images)

        print '[*] Sample images: {}'.format(sample_images.shape)

        # restore model
        if self.load_model():
            print '[*] Succeed to load model'
        else:
            print '[!] Failed to load model'
            
        for i, sample_image in enumerate(sample_images):

            print '[*] Generating fake face image conditioning on {}-th edge image...'.format(i+1)
            samples = self.sess.run(self.fake_B, feed_dict={ self.real_data: sample_image })

            image_path = '{}/output/{}.jpg'.format(self.dataset_dirname, i+1)
            save_images(samples, [self.batch_size, 1], image_path)

            print '[*] Save {}-th face image to "{}"'.format(i+1, image_path)
