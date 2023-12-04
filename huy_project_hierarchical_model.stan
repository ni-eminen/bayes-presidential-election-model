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
  real<lower=0, upper=10> alpha_a;
  real<lower=0, upper=10> beta_a;
  real<lower=0, upper=10> alpha_b;
  real<lower=0, upper=10> beta_b;
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
  alpha_a ~ uniform(0,10);
  beta_a ~ uniform(0,10);
  alpha_b ~ uniform(0,10);
  beta_b ~ uniform(0,10);
  
  for (n in 1:N_states) {
    a[n] ~ beta(alpha_a,beta_a);
    b[n] ~ beta(alpha_b,beta_b);
  }
  
  // Likelihood
  y_clinton ~ binomial(samplesize, theta_clinton[state_idx]);
  y_trump ~ binomial(samplesize, theta_trump[state_idx]);
}


generated quantities {
  array[N_observations] int y_clinton_pred;
  y_clinton_pred = binomial_rng(samplesize, theta_clinton[state_idx]);
}

