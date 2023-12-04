data {
  int<lower=0> N_observations;           // Number of data points
  int<lower=0> N_states;                 // Number of states
  array[N_observations] int samplesize;
  array[N_observations] int state_idx;
  array[N_observations] int y_clinton;
  array[N_observations] int y_trump;
}


parameters {
  vector<lower=0, upper=1>[N_states] a;
  vector<lower=0, upper=1>[N_states] b;
  real<lower=10, upper=20> alpha_a;
  real<lower=10, upper=20> beta_a;
  real<lower=10, upper=20> alpha_b;
  real<lower=10, upper=20> beta_b;
}


transformed parameters {
  vector[N_states] theta_clinton;
  vector[N_states] theta_trump;
  
  for (n in 1:N_states) {
    theta_clinton[n] = a[n];
    theta_trump[n] = b[n]*(1-a[n]);
  }
}


model {
  alpha_a ~ uniform(10,20);
  beta_a ~ uniform(10,20);
  alpha_b ~ uniform(10,20);
  beta_b ~ uniform(10,20);
  
  for (n in 1:N_states) {
    a[n] ~ beta(alpha_a,beta_a);
    b[n] ~ beta(alpha_b,beta_b);
  }
  
  // Likelihood
  y_clinton ~ binomial(samplesize, theta_clinton[state_idx]);
  y_trump ~ binomial(samplesize, theta_trump[state_idx]);
}


generated quantities {
  vector[N_observations] theta_clinton_pred;
  vector[N_observations] theta_trump_pred;
  for (n in 1:N_observations) {
    theta_clinton_pred[n] = binomial_rng(samplesize[n], theta_clinton[state_idx[n]])*1.0/samplesize[n];
    theta_trump_pred[n] = binomial_rng(samplesize[n], theta_trump[state_idx[n]])*1.0/samplesize[n];
  }
}
