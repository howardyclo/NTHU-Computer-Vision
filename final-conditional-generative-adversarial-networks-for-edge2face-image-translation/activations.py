import tensorflow as tf

""" Activation functions without trainable parameters """

def sigmoid(x):
    return tf.nn.sigmoid(x)

def tanh(x):
    return tf.nn.tanh(x)

def relu(x):
    return tf.nn.relu(x)

def lrelu(x, slope=0.2):
    return tf.maximum(x, slope*x)

def dropout(x, rate=0.5):
    return tf.nn.dropout(x, rate)

""" Activation functions with trainable parameters """

def conv2d(image, filter_num=1, filter_height=5, filter_width=5,
           stride_height=2, stride_width=2, name='conv2d'):

    input_channel = image.get_shape()[-1]

    with tf.variable_scope(name):
        W = tf.get_variable(name='w',
                            shape=(filter_height, filter_width, input_channel, filter_num),
                            initializer=tf.truncated_normal_initializer(stddev=0.02))

        b = tf.get_variable(name='biases',
                            shape=(filter_num),
                            initializer=tf.constant_initializer(0.0))

        conv = tf.nn.conv2d(image, W, strides=(1, stride_height, stride_width, 1), padding='SAME')
        conv = tf.reshape(tf.nn.bias_add(conv, b), conv.get_shape())

        return conv

def deconv2d(image, output_shape, filter_height=5, filter_width=5,
           stride_height=2, stride_width=2, name='deconv2d'):

    input_channel = image.get_shape()[-1]
    output_channel = output_shape[-1]

    with tf.variable_scope(name):
        W = tf.get_variable(name='w',
                            shape=(filter_height, filter_width, output_channel, input_channel),
                            initializer=tf.random_normal_initializer(stddev=0.02))

        b = tf.get_variable(name='biases',
                            shape=(output_channel),
                            initializer=tf.constant_initializer(0.0))

        deconv = tf.nn.conv2d_transpose(image, W, output_shape=output_shape, strides=(1, stride_height, stride_width, 1), padding='SAME')
        deconv = tf.reshape(tf.nn.bias_add(deconv, b), deconv.get_shape())

        return deconv

def linear(input_, output_size, scope=None, stddev=0.02, bias_start=0.0, with_w=False):
    shape = input_.get_shape().as_list()

    with tf.variable_scope(scope or 'Linear'):
        matrix = tf.get_variable('Matrix', [shape[1], output_size], tf.float32,
                                 tf.random_normal_initializer(stddev=stddev))
        bias = tf.get_variable('bias', [output_size],
            initializer=tf.constant_initializer(bias_start))
        if with_w:
            return tf.matmul(input_, matrix) + bias, matrix, bias
        else:
            return tf.matmul(input_, matrix) + bias

class batch_norm(object):
    def __init__(self, epsilon=1e-5, momentum=0.9, name='batch_norm'):
        with tf.variable_scope(name):
            self.epsilon = epsilon
            self.momentum = momentum
            self.name = name

    def __call__(self, x, train=True):
        return tf.contrib.layers.batch_norm(x, decay=self.momentum, updates_collections=None, epsilon=self.epsilon, scale=True, scope=self.name)
