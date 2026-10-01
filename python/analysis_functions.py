import pandas as pd
def calculate_summary(df):
    return pd.DataFrame({
        "total_policies":        [len(df)],
        "total_premium":         [df["premium"].sum()],
        "total_claims":          [df["total_claims"].sum()],
        "avg_loss_ratio_all":    [df["loss_ratio"].mean()],
        "avg_loss_ratio_claims": [df.loc[df["claim_count"] > 0, "loss_ratio"].mean()],
    })

def analyze_by_region(df):
    df_res = df.groupby("region").agg(
        policy_count = ("policy_id", "count"),
        premium = ("premium", "sum"),
        claims_sum = ("total_claims", "sum")
    )
    add_v1 = df.groupby("region").agg(
        pr_sum = ("premium", "sum"),
        cl_sum = ("total_claims", "sum")
    ).reset_index()
    add_v2 = df[df["claim_count"]>0].groupby("region").agg(
        pr_sum = ("premium", "sum"),
        cl_sum = ("total_claims", "sum")
    ).reset_index()

    add_v1["loss_ratio_all"] = (add_v1["cl_sum"]/add_v1["pr_sum"]).round(2)
    add_v2["loss_ratio_claims"] = (add_v2["cl_sum"]/add_v2["pr_sum"]).round(2)

    df_res = df_res.merge(
        add_v1[["region", "loss_ratio_all"]],
        on = "region"
    ).merge(
        add_v2[["region", "loss_ratio_claims"]],
        on = "region"
    )
    return df_res

def find_high_loss_policies(df):
    return df[df["loss_ratio"]>1]

def policy_type_stat(df):
    types_df = pd.read_csv("policy_types.csv")
    group_df =df.groupby("policy_type")["policy_id"].count().reset_index(name="policy_count")
    return types_df.merge(
        group_df,
        left_on = "type_id",
        right_on = "policy_type" 
    )[["type_name", "policy_count"]]

def prem_claim_stat(df):
    types_df = pd.read_csv("policy_types.csv")

    avg_prem = df.groupby("policy_type").agg(
        avg_premium=("premium", "mean"),
        avg_claims_all=("total_claims", "mean"),
    ).round(2).reset_index()
    
    avg_claim = df[df["claim_count"]>0].groupby("policy_type")["total_claims"].mean().round(2).reset_index(name="avg_claims")

    avg_stat = avg_prem.merge(
        avg_claim,
        on = "policy_type"
    )

    return types_df.merge(
        avg_stat,
        left_on = "type_id",
        right_on = "policy_type" 
    )[["type_name", "avg_premium", "avg_claims_all", "avg_claims"]]