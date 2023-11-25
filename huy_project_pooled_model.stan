data {
  int<lower=0> N_observations;
  int<lower=0> N_states;
  array[N_observations] int samplesize;
  array[N_observations] int state_idx; // Pair observations to their diets.
  vector[N_observations] y_clinton;
  vector[N_observations] y_trump;
  vector[N_observations] y_johnson;
}


parameters {
  vector<lower=0, upper=1>[N_states] a;
  vector<lower=0, upper=1>[N_states] b;
}


transformed parameters {
  vector[N_states] theta_clinton = a;
  vector[N_states] theta_trump = b*(1-a);
  vector[N_states] theta_johnson = 1 - a - b(1-a);
}


model {
  // Priors
  a ~ beta(2,2);
  b ~ beta(9,1);
  
  // Likelihood
  y_clinton ~ binomial(samplesize, theta_clinton);
  y_trump ~ binomial(samplesize, theta_trump);
  y_trump ~ binomial(samplesize, theta_trump);
}
