import pandas as pd
import analysis_functions as af
import matplotlib.pyplot as plt
import numpy as np
import seaborn as sns

def plot_policy_types_pie(df):
    a1 = af.policy_type_stat(df)
    fig, ax = plt.subplots(figsize=(7, 7))

    wedges, texts, autotexts = ax.pie(
        a1["policy_count"],
        labels=a1["type_name"],
        autopct="%1.1f%%",
        startangle=90,
        counterclock=False,
        colors=plt.cm.Set3(np.linspace(0, 1, len(a1))),
        wedgeprops={"width": 0.4, "edgecolor": "white"},
        pctdistance=0.8,
        textprops={"fontsize": 11},
    )

    total = a1["policy_count"].sum()
    ax.text(0, 0, f"Всего\n{total}",
            ha="center", va="center",
            fontsize=16, fontweight="bold")

    ax.set_title("Распределение полисов по типам", fontsize=14)
    fig.tight_layout()

    return fig


def plot_loss_ratio_by_type(df):
    a2 = af.prem_claim_stat(df)
    a2["loss_ratio_all"] = (a2["avg_claims_all"] / a2["avg_premium"]).round(2)
    
    fig, ax = plt.subplots(figsize=(9, 5))

    bars = ax.barh(a2["type_name"], a2["loss_ratio_all"])
    ax.axvline(1.0, color="red", linestyle="--", label="порог убыточности")
    ax.bar_label(bars, padding=3, fmt="%.2f")
    ax.set_xlabel("Loss ratio (claims / premium)")
    ax.set_title("Убыточность по типам полисов")
    ax.legend()

    fig.tight_layout()
    return fig

def plot_loss_ratio_by_region(df):
    a3 = af.analyze_by_region(df)
    
    mean_lr = a3["loss_ratio_all"].mean()

    fig, ax = plt.subplots(figsize=(10, 5))
    colors = ["#d9534f" if v > mean_lr else "#5cb85c" for v in a3["loss_ratio_all"]]
    bars = ax.bar(a3["region"], a3["loss_ratio_all"], color=colors)

    ax.axhline(mean_lr, 
               color="black", 
               linestyle="--",
               label=f"среднее = {mean_lr:.2f}")
    ax.bar_label(bars, padding=3, fmt="%.2f")
    ax.set_ylabel("Loss ratio")
    ax.set_title("Убыточность по регионам")
    ax.tick_params(axis="x", rotation=30)
    ax.legend()

    fig.tight_layout()
    return fig

def plot_heatmap_region_type(df):
    types_df = pd.read_csv("policy_types.csv")

    pivot = (
        df.merge(types_df, left_on="policy_type", right_on="type_id")
          .pivot_table(
              index="region", columns="type_name",
              values="loss_ratio", aggfunc="mean"
          )
    )

    pivot.columns = [c.replace(" ", "\n") for c in pivot.columns]

    fig, ax = plt.subplots(figsize=(12, 6))
    sns.heatmap(
        pivot,
        annot=True, fmt=".2f",
        cmap="RdYlGn_r", center=0.5,
        ax=ax,
        cbar_kws={"label": "Loss ratio"},
    )

    ax.set_xticklabels(ax.get_xticklabels(), rotation=0, ha="center")
    ax.set_yticklabels(ax.get_yticklabels(), rotation=0)
    ax.set_title("Loss ratio: регион × тип полиса")
    ax.set_xlabel("")
    ax.set_ylabel("Регион")

    fig.tight_layout()
    return fig