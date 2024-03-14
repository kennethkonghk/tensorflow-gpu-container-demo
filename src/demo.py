import sys
import warnings

import click
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import seaborn as sb
import tensorflow as tf
import yaml
from keras.callbacks import ModelCheckpoint
from keras.layers import Activation, Dense, Flatten
from keras.models import Sequential
from matplotlib import pyplot as plt
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_absolute_error
from sklearn.model_selection import train_test_split

warnings.filterwarnings("ignore")
warnings.filterwarnings("ignore", category=DeprecationWarning)
from xgboost import XGBRegressor


@click.command()
@click.argument("config")
@click.option("--exp_name", "-name", type=str, default=None)
def main(config, exp_name):
    print(f"This is experiment '{exp_name}'")

    with open(config, "r") as fid:
        cfg = yaml.load(fid, Loader=yaml.FullLoader)

    print("The config file:")
    print(cfg)

    print(f"Num GPUs Available: {len(tf.config.list_physical_devices('GPU'))}")


if __name__ == "__main__":
    main()
